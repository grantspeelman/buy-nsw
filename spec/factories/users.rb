FactoryBot.define do
  factory :user do
    sequence(:email) {|n| "user-#{n}@example.org" }
    sequence(:password) { SecureRandom.hex(8) }
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

    trait :with_approved_email do
      sequence(:email) {|n| "user-#{n}@example.nsw.gov.au" }
    end

    trait :without_approved_email do
      sequence(:email) {|n| "user-#{n}@example.org" }
    end

    factory :buyer_user, traits: [:buyer]
    factory :buyer_user_with_approved_email, traits: [:buyer, :with_approved_email]
    factory :buyer_user_without_approved_email, traits: [:buyer, :without_approved_email]

    factory :seller_user, traits: [:seller]
    factory :admin_user, traits: [:admin]
  end
end
