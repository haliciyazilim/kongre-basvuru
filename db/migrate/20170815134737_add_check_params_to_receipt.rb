class AddCheckParamsToReceipt < ActiveRecord::Migration[5.0]
  def change
    add_column :receipts, :response, :string
  end
end
