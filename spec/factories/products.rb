FactoryBot.define do
  factory :product do
    association :seller

    trait :inactive do
      state :inactive
    end

    trait :active do
      state :active
    end

    trait :with_basic_details do
      name 'Product name'
      summary 'Summary'
      section 'applications-services'
      audiences ['developers']
    end

    factory :inactive_product, traits: [:inactive]
    factory :active_product, traits: [:active, :with_basic_details]
  end
end
