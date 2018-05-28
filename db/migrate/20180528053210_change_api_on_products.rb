class ChangeApiOnProducts < ActiveRecord::Migration[5.1]
  def up
    change_column :products, :api, :string
  end

  def down
    change_column :products, :api, :boolean
  end
end
