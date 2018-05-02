class AddOnOffboardingFieldsToProducts < ActiveRecord::Migration[5.1]
  def change
    change_table :products do |t|
      t.text :onboarding_assistance
      t.text :offboarding_assistance
    end
  end
end
