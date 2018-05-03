class AddUserDataFieldsToProducts < ActiveRecord::Migration[5.1]
  def change
    change_table :products do |t|
      t.text :data_import_formats, default: [], array: true
      t.text :data_import_formats_other
      t.text :data_export_formats, default: [], array: true
      t.text :data_export_formats_other
      t.string :data_access

      t.string :audit_access_type
      t.string :audit_storage_period
      t.string :log_storage_period

      t.string :data_location
      t.text :data_location_other
      t.boolean :data_storage_control_australia
      t.boolean :third_party_infrastructure
      t.text :third_party_infrastructure_details

      t.text :backup_capability
      t.string :disaster_recovery_type
      t.string :backup_scheduling_type
      t.string :backup_recovery_type

      t.text :encryption_transit_user_types, default: [], array: true
      t.text :encryption_transit_user_other
      t.text :encryption_transit_network_types, default: [], array: true
      t.text :encryption_transit_network_other
      t.text :encryption_rest_types, default: [], array: true
      t.text :encryption_rest_other
    end
  end
end
