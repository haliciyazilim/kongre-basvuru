class AddForChildrenToWorkshops < ActiveRecord::Migration
  def change
    add_column :workshops, :for_children, :boolean, :default => false
    add_index :workshops, :for_children
  end
end
