class AddManagerApprovalTokenToBuyerApplications < ActiveRecord::Migration[5.1]
  def change
    add_column :buyer_applications, :manager_approval_token, :string
  end
end
