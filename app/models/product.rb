class Product < ActiveRecord::Base
  belongs_to :receipt
  has_many :receipt_products
end
