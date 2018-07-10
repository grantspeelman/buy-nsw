FactoryBot.define do
  factory :seller do

    # NOTE: The following blocks maintain support for passing an owner into the
    # factory (as per the previous behaviour)
    #
    transient do
      owner nil
    end

    after(:create) do |seller, evaluator|
      if evaluator.owner && evaluator.owner.seller_id != seller.id
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
      with_accreditation
      with_address
      with_award
      with_engagement
    end

    factory :active_seller, traits: [:active, :with_full_profile]
    factory :inactive_seller, traits: [:inactive]
    factory :inactive_seller_with_full_profile, traits: [:inactive, :with_full_profile]

    # TODO: Remove this in future
    factory :inactive_seller_with_tailor_fields, traits: [:inactive]
  end
end
