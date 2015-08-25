class CreateCardNumbers < ActiveRecord::Migration
  def change
    create_table :card_numbers do |t|
      t.belongs_to :applicant
    end

    add_index :card_numbers, :applicant_id, :unique => true
  end
end
