class AddEnvironmentFieldsToProducts < ActiveRecord::Migration[5.1]
  def change
    change_table :products do |t|
      t.string :deployment_model

      t.string :addon_extension_type
      t.text :addon_extension_details

      t.boolean :api
      t.text :api_capabilities
      t.text :api_automation
      t.boolean :api_documentation
      t.boolean :api_sandbox

      t.text :government_network_type, default: [], array: true
      t.string :government_network_other

      t.boolean :web_interface
      t.text :web_interface_details
      t.text :supported_browsers, default: [], array: true

      t.boolean :installed_application
      t.text :supported_os, default: [], array: true
      t.text :supported_os_other

      t.boolean :mobile_devices
      t.text :mobile_desktop_differences

      t.string :accessibility_type
      t.text :accessibility_exclusions

      t.string :scaling_type
    end
  end
end
