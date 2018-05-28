class AddUserSeparationFieldsToProducts < ActiveRecord::Migration[5.1]
  def change
    change_table :products do |t|
      t.boolean :virtualisation
      t.string :virtualisation_implementor
      t.string :virtualisation_third_party
      t.text :virtualisation_technologies, array: true, default: []
      t.text :virtualisation_technologies_other
      t.text :user_separation_details
    end
  end
end
