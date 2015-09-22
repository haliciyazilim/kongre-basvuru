class Applicant < ActiveRecord::Base
  after_destroy :after_destroy
  has_many :receipts
  has_one :card_number, dependent: :destroy

  def after_destroy
    ApplicantPresentation.where(applicant_id: self.id).destroy_all
  end

  def paid_workshops
    Workshop.joins(product: {receipt_products: :receipt}).where(receipts: {applicant_id: self.id, is_paid: true})
  end
end
