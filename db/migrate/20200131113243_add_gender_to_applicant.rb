class AddGenderToApplicant < ActiveRecord::Migration[5.0]
  def change
    add_column :applicants, :gender, :string
    add_column :applicants, :haberdar_olunan_yer, :string
  end
end
