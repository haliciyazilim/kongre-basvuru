class AddSeasonToProject < ActiveRecord::Migration
  def change
    add_column :applicants, :season, :integer
    add_column :applicant_presentations, :season, :integer

    add_column :products, :season, :integer
  end
end
