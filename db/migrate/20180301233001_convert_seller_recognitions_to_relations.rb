class ConvertSellerRecognitionsToRelations < ActiveRecord::Migration[5.1]
  def change
    remove_column :sellers, :accreditations, :text, array: true, default: []
    remove_column :sellers, :awards, :text, array: true, default: []
    remove_column :sellers, :industry_engagement, :text, array: true, default: []

    create_table :seller_accreditations do |t|
      t.integer :seller_id, null: false
      t.string :accreditation
      t.timestamps
    end
    add_foreign_key :seller_accreditations, :sellers, column: :seller_id

    create_table :seller_awards do |t|
      t.integer :seller_id, null: false
      t.string :award
      t.timestamps
    end
    add_foreign_key :seller_awards, :sellers, column: :seller_id

    create_table :seller_engagements do |t|
      t.integer :seller_id, null: false
      t.string :engagement
      t.timestamps
    end
    add_foreign_key :seller_engagements, :sellers, column: :seller_id
  end
end
