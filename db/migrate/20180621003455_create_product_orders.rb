class CreateProductOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :product_orders do |t|
      t.integer :buyer_id, null: false
      t.integer :product_id, null: false
      t.datetime :product_updated_at, null: false
      t.decimal :estimated_contract_value
      t.boolean :contacted_seller
      t.boolean :purchased_cloud_before

      t.timestamps
    end
  end
end
