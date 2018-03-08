class AddIndustryToSellers < ActiveRecord::Migration[5.1]
  def change
    change_table :sellers do |t|
      t.text :industry, default: [], array: true
    end
  end
end
