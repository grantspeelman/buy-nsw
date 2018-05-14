class RemoveStructuralChangesColumn < ActiveRecord::Migration[5.1]
  def change
    remove_column :sellers, :structural_changes, :boolean
    remove_column :sellers, :structural_changes_details, :text
  end
end
