class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  before_action :before_action

  def before_action
    response.headers['X-Frame-Options'] = 'ALLOWALL'
  end

  def show
    @workshops_24 = Workshop.at_day '2016-10-24'
    @workshops_25 = Workshop.at_day '2016-10-25'

  end

  def register

    if params[:applicant_id]
      applicant = Applicant.find(params[:applicant_id])
    end

    if params[:applicant]
      applicant = Applicant.create if !applicant
      applicant.update(:season => calculate_season)
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
      presentation = ApplicantPresentation.find_by_applicant_id(applicant.id)
      presentation = ApplicantPresentation.create(applicant_id: applicant.id) if !presentation
      presentation.update(:season => calculate_season)
      presentation.update(
          params[:presentation].permit(
              :purpose,
              :content,
              :audience
          ))
    end

    render :json => applicant
  end

  def order
    applicant = Applicant.find(params[:applicant_id])
    if !applicant || applicant.season != calculate_season
      return
    end
    ActiveRecord::Base.transaction do
      receipt = Receipt.create(applicant: applicant)
      if Attendance.last.product.season != calculate_season
        return
      end
      ReceiptProduct.create(
          receipt: receipt,
          product: Attendance.last.product,
          price: applicant.applicant_category == ApplicantCategory.instructor_student ? 10000 : 18000
      )
      if params[:workshops]
        params[:workshops].each do |workshop_id|
          workshop = Workshop.find(workshop_id)
          if workshop.product.season != calculate_season
            return
          end
          ReceiptProduct.create(
              receipt: receipt,
              product: workshop.product,
              price: workshop.product.price
          )
        end
      end
      receipt.update(price: receipt.calculate_total_amount)
      url = PaymentManager.checkout(
          user_id: applicant.id,
          user_name: applicant.name,
          order_id: receipt.id,
          product_name: 'Kongre Katılım',
          price: receipt.price,
          hostname: request.protocol + request.host_with_port
      )
      render json: {redirect_url: url}
    end
  end

  def callback
    @result = params[:result]
    @payment = PaymentManager.check(params[:payment_token])
    if @payment['status'] == 'successful'
      receipt = Receipt.find(@payment['order_id'])
      if !receipt.is_paid
        receipt.update(is_paid: true)
        receipt.receipt_products.each do |rp|
          rp.product.decrement!(:stock)
        end
        begin
          KongreMailer.payment_accepted(receipt).deliver!
        rescue
          puts 'An error occurred during mail sending!'
        end
      end
    end
  end


  def calculate_season
    if Time.now.month > 6
      return "#{Time.now.year.to_s}#{2}".to_i
    else
      return "#{Time.now.year.to_s}#{1}".to_i
    end
  end
end
