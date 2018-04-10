FactoryBot.define do
  factory :buyer do
    association :user

    trait :inactive do
      state :inactive
    end

    trait :active do
      state :active
    end

    trait :completed do
      name 'Buyer Buyer'
      organisation 'Organisation Name'
      employment_status 'employee'
    end

    factory :active_buyer, traits: [:active]
    factory :inactive_buyer, traits: [:inactive]
    factory :inactive_completed_buyer, traits: [:inactive, :completed]
  end
end
