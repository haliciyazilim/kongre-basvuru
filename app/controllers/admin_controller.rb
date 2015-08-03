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
    @total_amount = @receipts.map(&:price).reduce(:+)
    @receipts = @receipts.to_ary.group_by{|r| "#{r.created_at.day}.#{r.created_at.month}.#{r.created_at.year}"}
  end
  def applicant
    @applicant = Applicant.find(params[:id])
    @presentation = ApplicantPresentation.find_by_applicant_id(params[:id])
  end
end
