FactoryBot.define do
  factory :seller_version do
    association :seller
    created

    transient do
      owner nil
    end

    after(:create) do |seller_version, evaluator|
      if evaluator.owner && seller_version.seller.present?
        evaluator.owner.update_attribute(:seller_id, seller_version.seller.id)
      end
    end

    trait :with_tailor_fields do
      name 'Seller Ltd'
      summary 'We sell things'
      abn
      website_url 'http://example.org'
      linkedin_url 'http://linkedin.com/example'
      services [ 'cloud-services' ]
    end

    trait :with_full_seller_profile do
      with_tailor_fields

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

      agree true
    end

    trait :with_active_seller do
      association :seller, factory: :active_seller
    end

    trait :created do
      state 'created'
    end

    trait :awaiting_assignment do
      state 'awaiting_assignment'

      with_full_seller_profile
    end

    trait :ready_for_review do
      state 'ready_for_review'
      association :assigned_to, factory: :user

      with_full_seller_profile
    end

    trait :approved do
      state 'approved'
      response 'Well done!'

      with_full_seller_profile
      with_active_seller
    end

    trait :rejected do
      state 'rejected'
      response 'Sorry!'

      with_full_seller_profile
    end

    trait :returned_to_applicant do
      state 'created'
      response 'Almost there!'

      with_full_seller_profile
    end

    factory :created_seller_version, traits: [:created]
    factory :created_seller_version_with_profile, traits: [:created, :with_full_seller_profile]
    factory :awaiting_assignment_seller_version, traits: [:awaiting_assignment]
    factory :ready_for_review_seller_version, traits: [:ready_for_review]
    factory :approved_seller_version, traits: [:approved]
    factory :rejected_seller_version, traits: [:rejected]
    factory :returned_to_applicant_seller_version, traits: [:returned_to_applicant]
  end
end
