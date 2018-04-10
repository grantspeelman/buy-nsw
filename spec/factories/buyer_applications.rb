FactoryBot.define do
  factory :buyer_application do
    association :buyer
    state 'created'
    application_body 'Text'

    trait :created do
      state 'created'
    end

    factory :created_buyer_application, traits: [:created]
  end
end
