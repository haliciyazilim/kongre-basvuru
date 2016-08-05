class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|

      t.string :code
      t.float :amount
      t.integer :season
      t.string :coupon_type
      t.datetime :used_at 

      t.timestamps
    end
  end
end
