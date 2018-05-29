class AddCountryToSellerAddresses < ActiveRecord::Migration[5.1]
  def change
    add_column :seller_addresses, :country, :string
  end
end
