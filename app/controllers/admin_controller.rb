class AdminController < ApplicationController
  layout 'admin'

  # before_action :authenticate, only: [:coupon]
  before_action :htaccess

  def login
    if Digest::SHA1.hexdigest(params[:password] + ENV['ADMIN_SALT']) == Digest::SHA1.hexdigest(ENV['ADMIN_PASS'] + ENV['ADMIN_SALT'])
      @@authentication_token = Digest::SHA1.hexdigest(ENV['ADMIN_PASS'] + ENV['ADMIN_SALT'])
      @@authentication_at = Time.now
      redirect_to '/admin/coupon'
    else
      raise Exception
    end

  end

  def list
    if params.has_key? :applicant_type
      @applicants = Applicant.where(applicant_type: params[:applicant_type]).where(:season => calculate_season).order(id: :desc)
    else
      @applicants = Applicant.where(:season => calculate_season).order(id: :desc)
    end
  end

  def receipts
    if params.has_key? :is_paid
      @receipts = Receipt.includes(:applicant).where(is_paid: params[:is_paid]).where(:applicants => {:season => calculate_season}).where("price is not null").order(id: :desc)
    else
      @receipts = Receipt.includes(:applicant).where(:applicants => {:season => calculate_season}).where("price is not null").order(id: :desc)
    end
    @total_amount = @receipts.map(&:price).reduce(:+)
    @receipts = @receipts.to_ary.group_by { |r| "#{r.created_at.day}.#{r.created_at.month}.#{r.created_at.year}" }
  end

  def receipts_xlsx
    require 'spreadsheet'
    @receipts = Receipt.includes(:applicant).where(is_paid: true).where(:applicants => {:season => calculate_season}).where("price is not null").order(id: :desc)
    Spreadsheet.client_encoding = 'UTF-8'
    book = Spreadsheet::Workbook.new
    sheet1 = book.create_worksheet
    row = ['İsim', 'e-Posta', 'Telefon', 'Ürünler', 'Ücret']
    sheet1.insert_row(0, row)
    
    @receipts.each_with_index do |t, index|
      row = ["#{t.applicant.name} #{t.applicant.surname}", t.applicant.email, t.applicant.phone, t.receipt_products.map{|p| p.product.name}.join(','), t.price / 100]  
      sheet1.insert_row(index + 1, row)
    end 

    spreadsheet = StringIO.new
    book.write spreadsheet
    send_data spreadsheet.string, :filename => "Kongre Katılımcılar.xls", :type => "application/vnd.ms-excel"
  end

  def applicant
    @applicant = Applicant.find(params[:id])
    @workshops = @applicant.paid_workshops
    @presentation = ApplicantPresentation.find_by_applicant_id(params[:id])
  end

  def stocks
    @products = Product.where(:season => calculate_season).order(stock: :desc)
  end

  def coupon
    @count_used = Coupon.where(:season => calculate_season).where('used_at is not null').count
    @count_created = Coupon.where(:season => calculate_season).count
    @coupons = Coupon.where(:season => calculate_season).order('created_at desc')
  end

  def get_presentations_as_word

    applicantsPresentation=ApplicantPresentation.all

    template = Sablon.template(File.expand_path("public/presentations_template.docx"))
    context = {presentations: []}

    applicantsPresentation.each_with_index do |presentation, index|
      applicant_name="#{presentation.applicant.name} #{presentation.applicant.surname}"
      currentPresentation={
          index: index+1,
          applicant: {name: applicant_name, email: presentation.applicant.email, phone: presentation.applicant.phone},
          purpose: presentation.purpose,
          content: presentation.content,
          audience: presentation.audience
      }

      context[:presentations].push(currentPresentation)
    end

    data=template.render_to_string context

    send_data data, :filename => " Kongre Payment Rapor.docx"
  end
end
