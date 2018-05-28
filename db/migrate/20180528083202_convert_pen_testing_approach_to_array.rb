class ConvertPenTestingApproachToArray < ActiveRecord::Migration[5.1]
  def up
    remove_column :products, :penetration_testing_approach
    add_column :products, :penetration_testing_approach, :text, array: true
  end

  def down
    remove_column :products, :penetration_testing_approach
    add_column :products, :penetration_testing_approach, :string
  end
end
