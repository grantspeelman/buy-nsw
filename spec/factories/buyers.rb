FactoryBot.define do
  factory :buyer do
    association :user
    name 'Sarah'
    trait :inactive do
      state :inactive
    end

    trait :active do
      state :active
    end

    trait :contractor do
      employment_status 'contractor'
    end

    trait :completed do
      name 'Buyer Buyer'
      organisation 'Organisation Name'
      employment_status 'employee'
    end

    factory :active_buyer, traits: [:active, :completed]
    factory :inactive_buyer, traits: [:inactive]
    factory :inactive_completed_buyer, traits: [:inactive, :completed]
    factory :inactive_completed_contractor_buyer, traits: [:inactive, :completed, :contractor]
  end
end
