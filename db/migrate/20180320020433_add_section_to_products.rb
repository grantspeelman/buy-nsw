class AddSectionToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :section, :string
  end
end
