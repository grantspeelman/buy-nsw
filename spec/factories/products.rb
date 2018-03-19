FactoryBot.define do
  factory :product do
    association :seller

    trait :inactive do
      state :inactive
    end

    factory :inactive_product, traits: [:inactive]
  end
end
