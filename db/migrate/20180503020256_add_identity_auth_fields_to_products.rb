class AddIdentityAuthFieldsToProducts < ActiveRecord::Migration[5.1]
  def change
    change_table :products do |t|
      t.boolean :authentication_required
      t.text :authentication_types, default: [], array: true
      t.text :authentication_other
    end
  end
end
