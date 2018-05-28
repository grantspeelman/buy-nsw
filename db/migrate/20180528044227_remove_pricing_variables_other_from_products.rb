class RemovePricingVariablesOtherFromProducts < ActiveRecord::Migration[5.1]
  def change
    remove_column :products, :pricing_variables, :text, default: [], array: true
    rename_column :products, :pricing_variables_other, :pricing_variables
  end
end
