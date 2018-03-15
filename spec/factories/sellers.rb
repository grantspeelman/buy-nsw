FactoryBot.define do
  factory :seller do
    association :owner, factory: :user

    trait :inactive do
      state :inactive
    end

    trait :active do
      state :active
    end

    trait :with_address do
      after(:create) do |seller|
        create(:seller_address, seller: seller)
      end
    end

    trait :with_award do
      after(:create) do |seller|
        create(:seller_award, seller: seller)
      end
    end

    trait :with_engagement do
      after(:create) do |seller|
        create(:seller_engagement, seller: seller)
      end
    end

    trait :with_accreditation do
      after(:create) do |seller|
        create(:seller_accreditation, seller: seller)
      end
    end

    trait :with_full_profile do
      name 'Seller Ltd'
      summary 'We sell things'
      sequence(:abn) {|n| n.to_s.ljust(11, "0") }
      website_url 'http://example.org'
      linkedin_url 'http://linkedin.com/example'

      industry [ 'ict' ]

      number_of_employees '2to19'
      start_up true
      regional true
      state_government_experience true

      contact_name 'Seller Sellerton'
      contact_email 'seller@example.org'
      contact_phone '02 9123 4567'

      representative_name 'Signy Signerton'
      representative_email 'signy@example.org'
      representative_phone '02 9765 4321'

      tools 'Some tools'
      methodologies 'Some methodologies'
      technologies 'Some technologies'

      agree true

      with_accreditation
      with_address
      with_award
      with_engagement
    end

    factory :active_seller, traits: [:active, :with_full_profile]
    factory :inactive_seller, traits: [:inactive]
  end
end
