class Applicant < ActiveRecord::Base
  after_destroy :after_destroy
  has_many :receipts
  def after_destroy
    ApplicantPresentation.where(applicant_id: self.id).destroy_all
  end
end
