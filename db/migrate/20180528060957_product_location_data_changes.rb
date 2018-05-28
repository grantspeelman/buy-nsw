class ProductLocationDataChanges < ActiveRecord::Migration[5.1]
  def change
    rename_column :products, :data_storage_control_australia, :data_location_control

    rename_column :products, :third_party_infrastructure, :third_party_involved
    rename_column :products, :third_party_infrastructure_details, :third_party_involved_details

    add_column :products, :data_location_unknown_reason, :text
    add_column :products, :own_data_centre, :boolean
    add_column :products, :own_data_centre_details, :text
  end
end
