class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.text    :description
      t.integer :eventable_id
      t.string  :eventable_type
      t.integer :user_id
      t.timestamps
    end
  end
end
