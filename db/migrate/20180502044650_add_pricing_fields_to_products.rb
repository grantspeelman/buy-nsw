class AddPricingFieldsToProducts < ActiveRecord::Migration[5.1]
  def change
    change_table :products do |t|
      t.boolean :free_version
      t.text :free_version_details
      t.boolean :free_trial
      t.string :free_trial_url

      t.decimal :pricing_min
      t.decimal :pricing_max
      t.string :pricing_unit
      t.text :pricing_variables, array: true, default: []
      t.text :pricing_variables_other
      t.string :pricing_calculator_url

      t.boolean :education_pricing
      t.text :education_pricing_eligibility
      t.text :education_pricing_differences
    end
  end
end
