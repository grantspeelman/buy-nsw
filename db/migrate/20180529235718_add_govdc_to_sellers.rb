class AddGovdcToSellers < ActiveRecord::Migration[5.1]
  def change
    add_column :sellers, :govdc, :boolean
  end
end
