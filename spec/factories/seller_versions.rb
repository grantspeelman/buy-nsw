FactoryBot.define do
  factory :seller_version do
    association :seller
    created

    trait :with_full_seller_profile do
      association :seller, factory: :inactive_seller_with_full_profile
    end

    trait :created do
      state 'created'
    end

    trait :awaiting_assignment do
      state 'awaiting_assignment'
    end

    trait :ready_for_review do
      state 'ready_for_review'
      association :assigned_to, factory: :user
    end

    trait :approved do
      state 'approved'
      response 'Well done!'
    end

    trait :rejected do
      state 'rejected'
      response 'Sorry!'
    end

    trait :returned_to_applicant do
      state 'created'
      response 'Almost there!'
    end

    factory :created_seller_version, traits: [:created]
    factory :awaiting_assignment_seller_version, traits: [:awaiting_assignment, :with_full_seller_profile]
    factory :ready_for_review_seller_version, traits: [:ready_for_review]
    factory :approved_seller_version, traits: [:approved, :with_full_seller_profile]
    factory :rejected_seller_version, traits: [:rejected, :with_full_seller_profile]
    factory :returned_to_applicant_seller_version, traits: [:returned_to_applicant, :with_full_seller_profile]
  end
end
