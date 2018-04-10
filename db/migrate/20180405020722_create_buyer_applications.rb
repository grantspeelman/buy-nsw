class CreateBuyerApplications < ActiveRecord::Migration[5.1]
  def change
    create_table :buyer_applications do |t|
      t.string :state, null: false
      t.integer :buyer_id
      t.integer :assigned_to_id
      t.text :application_body
      t.text :decision_body
      t.datetime :started_at
      t.datetime :submitted_at
      t.datetime :decided_at
      t.timestamps
    end
  end
end
