class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  before_action :before_action
  def before_action
    response.headers['X-Frame-Options'] = 'ALLOWALL'
  end
  def show
    # @workshops_24 = Workshop.at_day '2015-10-24'
    # @workshops_25 = Workshop.at_day '2015-10-25'
  end

  def register
    return

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
      presentation = ApplicantPresentation.find_by_applicant_id(applicant.id)
      presentation = ApplicantPresentation.create(applicant_id:applicant.id) if ! presentation
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
    return
    applicant = Applicant.find(params[:applicant_id])
    ActiveRecord::Base.transaction do
      receipt = Receipt.create(applicant:applicant)
      if applicant.applicant_category != ApplicantCategory.child
        ReceiptProduct.create(
          receipt:receipt,
          product:Attendance.last.product,
          price:applicant.applicant_category == ApplicantCategory.instructor_student ? 10000 : 18000
        )
      end
      if params[:workshops]
        params[:workshops].each do |workshop_id|
          workshop = Workshop.find(workshop_id)
          ReceiptProduct.create(
            receipt:receipt,
            product:workshop.product,
            price:workshop.product.price
          )
        end
      end
      receipt.update(price:receipt.calculate_total_amount)
      url = PaymentManager.checkout(
        user_id: applicant.id,
        user_name: applicant.name,
        order_id: receipt.id,
        product_name: 'Kongre Katılım',
        price: receipt.price,
        hostname: request.protocol + request.host_with_port
      )
      render json: { redirect_url:url }
    end
  end

  def callback
    @result = params[:result]
    @payment = PaymentManager.check(params[:payment_token])
    if @payment['status'] == 'successful'
      receipt = Receipt.find(@payment['order_id'])
      if !receipt.is_paid
        CardNumber.create(:applicant_id => receipt.applicant_id)
        receipt.update(is_paid:true)
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


end
