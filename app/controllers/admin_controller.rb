class AdminController < ApplicationController
  layout 'admin'
  def list
    @applicants = Applicant.all
  end
  def applicant
    @applicant = Applicant.find(params[:id])
  end
end
