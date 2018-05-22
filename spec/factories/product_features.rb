FactoryBot.define do
  factory :product_feature do
    association :product
    sequence(:feature) {|n| "Feature #{n}" }
  end
end
