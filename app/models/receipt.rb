class Receipt < ActiveRecord::Base
  belongs_to :applicant
  has_many :receipt_products
  def calculate_total_amount
    ReceiptProduct.where(receipt: self).sum(:price)
  end
end
