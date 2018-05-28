class UpdateDataAccessFieldsOnProducts < ActiveRecord::Migration[5.1]
  def up
    remove_column :products, :data_access
    remove_column :products, :audit_access_type

    add_column :products, :audit_information, :boolean
    add_column :products, :data_access_restrictions, :boolean
    add_column :products, :data_access_restrictions_details, :text
  end

  def down
    remove_column :products, :audit_information
    remove_column :products, :data_access_restrictions
    remove_column :products, :data_access_restrictions_details

    add_column :products, :audit_access_type, :string
    add_column :products, :data_access, :string
  end
end
