class AddDataDisposalApproachToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :data_disposal_approach, :text
  end
end
