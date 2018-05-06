class AddAvailabilitySupportFieldsToProducts < ActiveRecord::Migration[5.1]
  def change
    change_table :products do |t|
      t.text :guaranteed_availability
      t.text :support_options, default: [], array: true
      t.text :support_hours
      t.text :support_levels
    end
  end
end
