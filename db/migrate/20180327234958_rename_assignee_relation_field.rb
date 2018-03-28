class RenameAssigneeRelationField < ActiveRecord::Migration[5.1]
  def change
    rename_column :seller_applications, :assigned_to, :assigned_to_id
  end
end
