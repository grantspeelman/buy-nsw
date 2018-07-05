class RenameSellerApplicationsToSellerVersions < ActiveRecord::Migration[5.1]
  def change
    rename_table :seller_applications, :seller_versions
  end
end
