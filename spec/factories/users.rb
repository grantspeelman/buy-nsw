FactoryBot.define do
  factory :user do
    sequence(:email) {|n| "user-#{n}@example.org" }
    sequence(:password) { SecureRandom.hex(8) }
    confirmed_at 1.day.ago

    trait :buyer do
      roles ['buyer']
    end

    trait :active_buyer do
      roles ['buyer']

      after :create do |user|
        create(:active_buyer, user: user)
      end
    end

    trait :seller do
      roles ['seller']
    end

    trait :with_seller do
      after :create do |user, evaluator|
        seller = evaluator.seller || create(:seller, owner: user)
        user.update_attribute(:seller_id, seller.id)
      end
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
    factory :active_buyer_user, traits: [:active_buyer]
    factory :buyer_user_with_approved_email, traits: [:buyer, :with_approved_email]
    factory :buyer_user_without_approved_email, traits: [:buyer, :without_approved_email]

    factory :seller_user, traits: [:seller]
    factory :seller_user_with_seller, traits: [:seller, :with_seller]
    factory :admin_user, traits: [:admin]
  end
end
