class AddTailorCompletedToSellerApplications < ActiveRecord::Migration[5.1]
  def change
    add_column :seller_applications, :tailor_complete, :boolean, default: false
  end
end
