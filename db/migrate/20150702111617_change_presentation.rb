class ChangePresentation < ActiveRecord::Migration
  def change
    change_column :presentations, :purpose, :text
    change_column :presentations, :audience, :text
  end
end
