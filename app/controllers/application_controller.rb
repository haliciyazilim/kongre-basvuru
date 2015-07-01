class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  def show

  end

  def register

    if params[:applicant_id]
      applicant = Applicant.find(params[:applicant_id])
    else
      applicant = Applicant.create
    end
    permitted_params = params.permit(
      :name,
      :surname,
      :email,
      :tckn,
      :birthday,
      :phone,
      :organization,
      :occupation,
      :address,
      :city,
      :relation_to_high_intelligence,
      :previous_attendances,
      :applicant_category,
      :applicant_type
    )

    session[:applicant_type] = applicant.update(permitted_params)
    render :json => applicant
  end

end
