class CreateSellers < ActiveRecord::Migration[5.1]
  def change
    create_table :sellers do |t|
      t.integer :owner_id, null: false
      t.string :state, null: false
      t.string :name
      t.timestamps
    end
    add_foreign_key :sellers, :users, column: :owner_id

    change_table :seller_applications do |t|
      t.integer :seller_id, null: false
    end
    add_foreign_key :seller_applications, :sellers
  end
end
