class CreateProductFeatures < ActiveRecord::Migration[5.1]
  def change
    create_table :product_features do |t|
      t.integer :product_id
      t.string :feature

      t.timestamps
    end
  end
end
