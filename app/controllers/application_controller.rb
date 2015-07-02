class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  def show

  end

  def register
    if params[:applicant_id]
      applicant = Applicant.find(params[:applicant_id])
    end

    if params[:applicant]
      applicant = Applicant.create if !applicant
      session[:applicant_type] = applicant.update(
        params[:applicant].permit(
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
        ))
    end

    if params[:presentation] && applicant
      presentation = Presentation.find_by_applicant_id(applicant.id)
      presentation = Presentation.create(applicant_id:applicant.id) if ! presentation
      presentation.update(
        params[:presentation].permit(
          :purpose,
          :content,
          :audience
        ))
    end

    render :json => applicant
  end


end
