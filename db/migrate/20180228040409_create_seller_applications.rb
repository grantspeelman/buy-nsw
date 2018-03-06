class CreateSellerApplications < ActiveRecord::Migration[5.1]
  def change
    create_table :seller_applications do |t|
      t.integer :owner_id, null: false
      t.string :state, null: false
      t.text :response

      t.datetime :started_at
      t.datetime :submitted_at
      t.datetime :decided_at
    end
    add_foreign_key :seller_applications, :users, column: :owner_id
  end
end
