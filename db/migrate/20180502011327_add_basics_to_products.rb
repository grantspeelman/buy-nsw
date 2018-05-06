class AddBasicsToProducts < ActiveRecord::Migration[5.1]
  def change
    change_table :products do |t|
      t.string :reseller_type
      t.string :organisation_resold
      t.boolean :custom_contact
      t.string :contact_name
      t.string :contact_email
      t.string :contact_phone
    end
  end
end
