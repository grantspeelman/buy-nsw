class AddNonProfitPricingToProducts < ActiveRecord::Migration[5.1]
  def change
    change_table :products do |t|
      t.boolean :not_for_profit_pricing
      t.text :not_for_profit_pricing_eligibility
      t.text :not_for_profit_pricing_differences
    end
  end
end
