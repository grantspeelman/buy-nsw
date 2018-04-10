class CreateBuyers < ActiveRecord::Migration[5.1]
  def change
    create_table :buyers do |t|
      t.integer :user_id
      t.string :organisation
      t.timestamps
    end
  end
end
