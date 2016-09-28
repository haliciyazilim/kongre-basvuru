class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  before_action :before_action

  @@authentication_token = ""
  @@authentication_at = Time.now

  def before_action
    response.headers['X-Frame-Options'] = 'ALLOWALL'
  end

  def show
    @workshops_24 = Workshop.at_day '2016-11-19'
    @workshops_25 = Workshop.at_day '2016-07-29'
  end

  def register

    if params[:applicant_id]
      applicant = Applicant.find(params[:applicant_id])
    end

    if params[:applicant]
      applicant = Applicant.create if !applicant
      applicant.update(:season => calculate_season)
      params[:applicant][:name]= params[:applicant][:name].titleize
      params[:applicant][:surname] = params[:applicant][:surname].titleize
      params[:applicant][:occupation] = params[:applicant][:occupation].titleize
      params[:applicant][:organization] = params[:applicant][:organization].titleize
      params[:applicant][:address] = params[:applicant][:address].titleize
      params[:applicant][:email] = params[:applicant][:email].downcase.strip
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
              :applicant_type,
              :season
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

  def coupon_check
    begin
      raise NoCouponException unless params[:code]
      @coupon = Coupon.find_by_code params[:code]
      raise NoCouponException if @coupon.nil?
      raise NoCouponException unless @coupon.season == calculate_season
      raise NoCouponException unless @coupon.email == params[:email]
      raise UsedCouponException unless @coupon.used_at.nil?
      render 'coupons/show.json'
    rescue NoCouponException
      show_error ErrorCodeNoCouponDefined, "Lütfen geçerli bir kupon koduna sahip olduğunuzdan emin olunuz."
    rescue UsedCouponException
      show_error ErrorCodeUsedCouponException, "Bu kupon kodu kullanılmış, size ait ve siz kullanmadıysanız lütfen bizimle iletişime geçiniz."
    end
  end

  def coupon_create
    begin
      if params[:type] == '1'
        code = rand(36**8).to_s(36).upcase
        while !Coupon.where(:code => code).blank?
          code = rand(36**8).to_s(36).upcase
        end
        Coupon.create(:code => code, :amount => 95, :season => calculate_season, :email => params[:email].strip, :coupon_type => 'metu_student')
        begin
          KongreMailer.send_coupon_mail(params[:email].strip, code).deliver!
        rescue
          puts 'Email could not be sent'
        end
        redirect_to '/admin/coupon'
      elsif params[:type] == '2'
        code = rand(36**8).to_s(36).upcase
        while !Coupon.where(:code => code).blank?
          code = rand(36**8).to_s(36).upcase
        end
        Coupon.create(:code => code, :amount => 120, :season => calculate_season, :email => params[:email].strip, :coupon_type => 'free')

        begin
          KongreMailer.send_coupon_mail(params[:email].strip, code).deliver!
        rescue
          puts 'Email could not be sent'
        end

        redirect_to '/admin/coupon'
      elsif params[:type] == '3'
        code = rand(36**8).to_s(36).upcase
        while !Coupon.where(:code => code).blank?
          code = rand(36**8).to_s(36).upcase
        end
        Coupon.create(:code => code, :amount => 60, :season => calculate_season, :email => params[:email].strip, :coupon_type => 'half')

        begin
          KongreMailer.send_coupon_mail(params[:email].strip, code).deliver!
        rescue
          puts 'Email could not be sent'
        end

        redirect_to '/admin/coupon'
      else
        puts "------"
      end
    rescue

    end
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
      coupon_discount = 0
      if params[:coupon_code]
        @coupon = Coupon.find_by_code(params[:coupon_code])
        coupon_discount = @coupon.nil? ? 0 : @coupon.amount
        @coupon.update(:applicant => applicant) unless @coupon.nil?
      end
      ReceiptProduct.create(
          receipt: receipt,
          product: Attendance.last.product,
          price: applicant.applicant_category == ApplicantCategory.instructor_student ? 10000 - coupon_discount * 100 : 12000 - coupon_discount * 100
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
      if receipt.price > 0
        url = PaymentManager.checkout(
            user_id: applicant.id,
            user_name: applicant.name + ' ' + applicant.surname,
            order_id: receipt.id,
            product_name: 'Kongre Katılım',
            price: receipt.price,
            addr: applicant.address,
            hostname: request.protocol + request.host_with_port
        )
        render json: {redirect_url: url}
      else
        receipt.update(:is_paid => true)
        receipt.receipt_products.each do |rp|
          rp.product.decrement!(:stock)
        end
        coupon = Coupon.find_by_season_and_applicant_id(calculate_season, receipt.applicant_id)
        coupon.update(:used_at => Time.now) unless coupon.nil?
        begin
          KongreMailer.create_free_order_accepted(receipt).deliver!
        rescue
          puts 'An error occurred during free order accepted mail sending!'
        end
        render json: {text: 'Başvurunuz tamamlandı. Tebrikler.'}
      end
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
        coupon = Coupon.find_by_season_and_applicant_id(calculate_season, receipt.applicant_id)
        coupon.update(:used_at => Time.now) unless coupon.nil?
        begin
          KongreMailer.payment_accepted(receipt).deliver!
        rescue
          puts 'An error occurred during mail sending!'
        end
      end
    end
  end

  def show_error error_code, description
    if !Rails.env.test?
      err_id = rand(1000..10000)
      puts "Error #{err_id.to_s} for parameters: "
      puts "[err_id:#{err_id.to_s}] Error code is #{error_code.to_s} and description: #{description.to_s}"
      params.each do |k, v|
        puts "[err_id:#{err_id}]  #{k.to_s} = #{v.to_s}"
      end
    end

    # redirect_to :controller => "error",:error_code => error_code, :description => description, :format => params[:format]
    # head @error_code
    response.headers["error"] = "true"
    response.headers["error_code"] = error_code.to_s
    @error_code = error_code
    @error_description = description
    @error_title = ErrorDescriptionTable[@error_code.to_i]
    render 'layouts/error.json', :status => :bad_request, :format => :json
  end

  def calculate_season
    if Time.now.month > 6
      return "#{Time.now.year.to_s}#{2}".to_i
    else
      return "#{Time.now.year.to_s}#{1}".to_i
    end
  end

  def self.calculate_season
    if Time.now.month > 6
      return "#{Time.now.year.to_s}#{2}".to_i
    else
      return "#{Time.now.year.to_s}#{1}".to_i
    end
  end

  def authenticate
    unless @@authentication_token == Digest::SHA1.hexdigest(ENV['ADMIN_PASS'] + ENV['ADMIN_SALT'])
      render 'admin/login'
    else
      if Time.now > @@authentication_at + 1.minute
        @@authentication_token = ''
        render 'admin/login'
      end
      @@authentication_at = Time.now
    end
  end

end


class NoCouponException < StandardError;
end

class UsedCouponException < StandardError;
end