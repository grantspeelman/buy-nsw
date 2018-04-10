FactoryBot.define do
  factory :buyer do
    association :user

    trait :completed do
      name 'Buyer Buyer'
      organisation 'Organisation Name'
      employment_status 'employee'
    end

    factory :completed_buyer, traits: [:completed]
  end
end
