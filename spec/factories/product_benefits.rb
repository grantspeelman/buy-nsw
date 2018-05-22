FactoryBot.define do
  factory :product_benefit do
    association :product
    sequence(:benefit) {|n| "Benefit #{n}" }
  end
end
