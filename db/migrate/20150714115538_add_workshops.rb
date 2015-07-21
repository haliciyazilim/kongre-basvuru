class AddWorkshops < ActiveRecord::Migration
  def change

    create_table :products do |t|
      t.integer :stock
      t.integer :price
      t.string :product_type
      t.string :name

      t.timestamps
    end

    create_table :workshops do |t|
      t.datetime :start_at
      t.datetime :finish_at
      t.string :saloon
      t.string :moderator
      t.belongs_to :product
    end

    create_table :attendances do |t|
      t.belongs_to :product
    end

    create_table :receipts do |t|
      t.belongs_to :applicant
      t.integer :price
      t.boolean :is_paid, :default => false

      t.timestamps
    end

    create_table :receipt_products do |t|
      t.belongs_to :receipt
      t.belongs_to :product
      t.integer :price
    end

  end
end
