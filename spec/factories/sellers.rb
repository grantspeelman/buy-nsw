FactoryBot.define do
  factory :seller do
    association :owner, factory: :user
    state :inactive

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

    after(:create) do |seller|
      create(:seller_address, seller: seller)
      create(:seller_accreditation, seller: seller)
      create(:seller_award, seller: seller)
      create(:seller_engagement, seller: seller)
    end

    trait :inactive do
      state :inactive
    end
    trait :active do
      state :active
    end

    factory :active_seller, traits: [:active]
    factory :inactive_seller, traits: [:inactive]
  end
end
