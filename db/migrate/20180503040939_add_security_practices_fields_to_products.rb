class AddSecurityPracticesFieldsToProducts < ActiveRecord::Migration[5.1]
  def change
    change_table :products do |t|
      t.string :secure_development_approach
      t.string :penetration_testing_frequency
      t.string :penetration_testing_approach
    end
  end
end
