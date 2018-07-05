FactoryBot.define do
  factory :product_order do
    association :product, factory: :active_product
    association :buyer, factory: :active_buyer
    product_updated_at 1.day.ago
    estimated_contract_value 75000
    contacted_seller false
    purchased_cloud_before true
  end
end
