class Product < ActiveRecord::Base
  belongs_to :receipt
  has_many :receipt_products

  def applicants
    r = receipt_products.map{|t| t.receipt if t.receipt.is_paid == true}.compact
    r.map{|t| {name: "#{t.applicant.name} #{t.applicant.surname}", email: t.applicant.email, phone: t.applicant.phone}}
  end
end
