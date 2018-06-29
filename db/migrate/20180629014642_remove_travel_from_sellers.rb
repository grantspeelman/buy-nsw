class RemoveTravelFromSellers < ActiveRecord::Migration[5.1]
  def change
    remove_column :sellers, :travel, :boolean
  end
end
