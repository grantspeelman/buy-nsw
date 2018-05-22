class CreateWaitingSellers < ActiveRecord::Migration[5.1]
  def change
    create_table :waiting_sellers do |t|
      t.string :name, null: false
      t.string :abn, null: false
      t.string :address
      t.string :suburb
      t.string :postcode
      t.string :state
      t.string :country
      t.string :contact_name
      t.string :contact_email
      t.string :contact_position
      t.string :website_url

      t.string :invitation_state, null: false
      t.string :invitation_token
      t.datetime :invited_at
      t.datetime :joined_at
      t.integer :seller_id

      t.timestamps
    end
  end
end
