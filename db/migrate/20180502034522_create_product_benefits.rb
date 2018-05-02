class CreateProductBenefits < ActiveRecord::Migration[5.1]
  def change
    create_table :product_benefits do |t|
      t.integer :product_id
      t.string :benefit

      t.timestamps
    end
  end
end
