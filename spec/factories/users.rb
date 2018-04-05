FactoryBot.define do
  factory :user do
    sequence(:email) {|n| "user-#{n}@example.org" }
    password '12345678'
    confirmed_at 1.day.ago

    trait :buyer do
      roles ['buyer']
    end

    trait :seller do
      roles ['seller']
    end

    trait :admin do
      roles ['admin']
    end

    factory :buyer_user, traits: [:buyer]
    factory :seller_user, traits: [:seller]
    factory :admin_user, traits: [:admin]
  end
end
