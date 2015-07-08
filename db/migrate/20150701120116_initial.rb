class Initial < ActiveRecord::Migration

  def change

    create_table :applicants do |t|
      t.string :name
      t.string :surname
      t.string :email
      t.string :tckn
      t.date :birthday
      t.string :phone
      t.string :organization
      t.string :occupation
      t.text :address
      t.string :city
      t.string :relation_to_high_intelligence
      t.string :previous_attendances
      t.string :applicant_category
      t.string :applicant_type
      t.timestamps
    end

    create_table :presentations do |t|
      t.belongs_to :applicant
      t.text :purpose
      t.text :content
      t.text :audience
      t.timestamps
    end

  end

end
