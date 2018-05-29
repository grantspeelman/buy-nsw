FactoryBot.define do
  factory :waiting_seller do
    name 'Seller In Waiting'
    sequence(:abn) {|n| build_abn(n) }
    address '123 Test Street'
    suburb 'Test Suburb'
    postcode '2000'
    state 'nsw'
    country 'AU'
    contact_name 'Joe Bloggs'
    sequence(:contact_email) {|n| "waiting-seller-#{n}@test.buy.nsw.gov.au" }
    contact_position 'Chief of Staff'
    website_url 'https://example.buy.nsw.gov.au'

    trait :invited do
      invitation_state 'invited'
      invitation_token { SecureRandom.hex(8) }
      invited_at { 1.hour.ago }
    end

    trait :joined do
      invitation_state 'joined'
      joined_at { 5.minutes.ago }
      association :seller
    end

    factory :invited_waiting_seller, traits: [:invited]
    factory :joined_waiting_seller, traits: [:joined]
  end
end
