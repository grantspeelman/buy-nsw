FactoryBot.define do
  factory :seller_application do
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

    trait :assigned do
      state 'assigned'
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

    factory :created_seller_application, traits: [:created]
    factory :awaiting_assignment_seller_application, traits: [:awaiting_assignment, :with_full_seller_profile]
    factory :assigned_seller_application, traits: [:assigned]
    factory :approved_seller_application, traits: [:approved, :with_full_seller_profile]
    factory :rejected_seller_application, traits: [:rejected, :with_full_seller_profile]
    factory :returned_to_applicant_seller_application, traits: [:returned_to_applicant, :with_full_seller_profile]
  end
end
