class Applicant < ActiveRecord::Base
  after_destroy :after_destroy
  def after_destroy
    ApplicantPresentation.where(applicant_id: self.id).destroy_all
  end
end
