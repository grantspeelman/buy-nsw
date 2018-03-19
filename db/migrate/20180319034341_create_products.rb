class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.integer :seller_id, null: false
      t.string :state, null: false
      t.string :name
      
      t.timestamps
    end
  end
end
