class AddPricingCurrencyToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :pricing_currency, :string
    add_column :products, :pricing_currency_other, :string
  end
end
