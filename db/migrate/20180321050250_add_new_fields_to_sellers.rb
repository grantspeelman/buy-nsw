class AddNewFieldsToSellers < ActiveRecord::Migration[5.1]
  def change
    add_column :sellers, :australian_owned, :boolean
    add_column :sellers, :rural_remote, :boolean
  end
end
