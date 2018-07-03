class Attendance < ActiveRecord::Base
  belongs_to :product

  def self.create_product(params)
    transaction do
      params[:product_type] = 'attendance'
      params[:product] = Product.create(params.retrieve(:name,:price,:product_type,:stock,:max_stock,:season))
      return create(params.retrieve(:product))
    end
  end

end
