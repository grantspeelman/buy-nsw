class ChangeBackupRecoveryFieldsOnProducts < ActiveRecord::Migration[5.1]
  def up
    change_column :products, :backup_capability, :string
    remove_column :products, :disaster_recovery_type
  end

  def down
    change_column :products, :backup_capability, :text
    add_column :products, :disaster_recovery_type, :string
  end
end
