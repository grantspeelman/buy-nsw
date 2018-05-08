FactoryBot.define do
  factory :seller do

    # NOTE: The following blocks maintain support for passing an owner into the
    # factory (as per the previous behaviour)
    #
    transient do
      owner nil
    end

    after(:create) do |seller, evaluator|
      if evaluator.owner
        evaluator.owner.update_attribute(:seller_id, seller.id)
      else
        create(:seller_user, seller: seller)
      end
    end

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
      sequence(:abn) do |n|
        main = n.to_s.rjust(9, "0")
        weights = [3, 5, 7, 9, 11, 13, 15, 17, 19]
        sum = 0
        (0..8).each do |i|
          digit = main[i,1].to_i
          sum += weights[i] * digit
        end
        checksum = 99 - sum % 89
        checksum_string = checksum.to_s.rjust(2, "0")
        checksum_string + main
      end
      website_url 'http://example.org'
      linkedin_url 'http://linkedin.com/example'

      industry [ 'ict' ]

      number_of_employees '2to4'
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
    factory :inactive_seller_with_full_profile, traits: [:inactive, :with_full_profile]
  end
end
