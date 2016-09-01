class AddColumnToCoupon < ActiveRecord::Migration
  def change
    add_belongs_to :coupons, :applicant
    add_column :coupons, :email, :string
  end
end
