class RemovePrimaryFieldFromSellerAddresses < ActiveRecord::Migration[5.1]
  def change
    remove_column :seller_addresses, :primary, :boolean
  end
end
