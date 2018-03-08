class CreateSellerAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :seller_addresses do |t|
      t.integer :seller_id, null: false
      t.string :address
      t.string :suburb
      t.string :state
      t.string :postcode
      t.boolean :primary

      t.timestamps
    end
  end
end
