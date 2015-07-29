class AdminController < ApplicationController
  layout 'admin'
  def list
    @applicants = Applicant.all.order(id: :desc)
  end
  def receipts
    if params.has_key? :is_paid
      @receipts = Receipt.where(is_paid: params[:is_paid]).order(id: :desc)
    else
      @receipts = Receipt.all.order(id: :desc)
    end
  end
  def applicant
    @applicant = Applicant.find(params[:id])
    @presentation = ApplicantPresentation.find_by_applicant_id(params[:id])
  end
end
