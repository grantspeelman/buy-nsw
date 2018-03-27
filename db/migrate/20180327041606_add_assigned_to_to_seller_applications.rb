class AddAssignedToToSellerApplications < ActiveRecord::Migration[5.1]
  def change
    add_column :seller_applications, :assigned_to, :integer
  end
end
