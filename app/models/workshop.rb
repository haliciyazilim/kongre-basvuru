class Workshop < ActiveRecord::Base

  belongs_to :product

  def self.create_product(params)
    transaction do
      params[:product_type] = 'workshop'
      params[:product] = Product.create(params.retrieve(:name,:price,:product_type,:stock,:max_stock, :season))
      return create(params.retrieve(:start_at,:finish_at,:saloon, :moderator, :product))
    end
  end

  def self.at_day(date)
    date = DateTime.parse(date) if date.is_a? String
    where('start_at > ? AND start_at < ?',date.at_beginning_of_day,date.at_end_of_day)
  end

  def as_json(options ={})
    json = super.as_json options
    json[:product] = self.product.as_json options
    return json
  end

  def attendees
    Applicant.joins(receipts: :receipt_products).where(receipts: {:is_paid => true}, receipt_products: {:product_id => self.product_id})
  end

end
