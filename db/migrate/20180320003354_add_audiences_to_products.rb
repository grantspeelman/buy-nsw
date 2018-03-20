class AddAudiencesToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :audiences, :text, default: [], array: true
  end
end
