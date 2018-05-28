class AddEncryptionKeysControllerToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :encryption_keys_controller, :string
  end
end
