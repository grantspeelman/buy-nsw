class AddOpsecFieldsToProducts < ActiveRecord::Migration[5.1]
  def change
    change_table :products do |t|
      t.string :change_management_processes
      t.text :change_management_approach
      t.string :vulnerability_processes
      t.text :vulnerability_approach
      t.string :protective_monitoring_processes
      t.text :protective_monitoring_approach
      t.string :incident_management_processes
      t.text :incident_management_approach
      t.string :access_control_testing_frequency
    end
  end
end
