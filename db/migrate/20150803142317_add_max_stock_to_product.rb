class AddMaxStockToProduct < ActiveRecord::Migration
  def change
    add_column :products, :max_stock, :integer, :default => 100
  end
end
