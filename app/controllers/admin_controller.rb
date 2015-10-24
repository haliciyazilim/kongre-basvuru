class AdminController < ApplicationController
  layout 'admin'
  def list
    if params.has_key? :applicant_type
      @applicants = Applicant.where(applicant_type: params[:applicant_type]).order(id: :desc)
    else
      @applicants = Applicant.all.order(id: :desc)
    end
  end

  def receipts
    if params.has_key? :is_paid
      @receipts = Receipt.where(is_paid: params[:is_paid]).order(id: :desc)
    else
      @receipts = Receipt.all.order(id: :desc)
    end
    @total_amount = @receipts.map(&:price).reduce(:+)
    @receipts = @receipts.to_ary.group_by{|r| "#{r.created_at.day}.#{r.created_at.month}.#{r.created_at.year}"}
  end
  def applicant
    @applicant = Applicant.find(params[:id])
    @workshops = @applicant.paid_workshops

    @presentation = ApplicantPresentation.find_by_applicant_id(params[:id])
  end
  def stocks
    @products = Product.all
  end

  def get_presentations_as_word

    applicantsPresentation=ApplicantPresentation.all

    template = Sablon.template(File.expand_path("public/presentations_template.docx"))
    context = {presentations:[]}

    applicantsPresentation.each_with_index  do |presentation, index|
      applicant_name="#{presentation.applicant.name} #{presentation.applicant.surname}"
      currentPresentation={
          index:index+1,
          applicant:{name:applicant_name,email:presentation.applicant.email, phone:presentation.applicant.phone},
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
