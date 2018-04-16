class RemoveOwnerIdFromSellerApplications < ActiveRecord::Migration[5.1]
  def change
    remove_column :seller_applications, :owner_id, :integer, null: false
  end
end
