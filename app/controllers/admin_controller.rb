class AdminController < ApplicationController
  layout 'admin'
  def list
    @applicants = Applicant.all.order(id: :desc)
  end
  def applicant
    @applicant = Applicant.find(params[:id])
    @presentation = ApplicantPresentation.find_by_applicant_id(params[:id])
  end
end
