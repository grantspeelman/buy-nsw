FactoryBot.define do
  factory :product_order do
    association :product
    association :buyer
    product_updated_at 1.day.ago
    estimated_contract_value 75000
    contacted_seller false
    purchased_cloud_before true
  end
end
