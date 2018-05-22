class RemoveIndustryFromSellers < ActiveRecord::Migration[5.1]
  def change
    remove_column :sellers, :industry, :text
  end
end
