FactoryBot.define do
  factory :buyer_application do
    association :buyer
    state 'created'
    application_body 'Text'

    trait :with_completed_buyer_profile do
      association :buyer, factory: :inactive_completed_buyer
    end

    trait :manager_approval do
      manager_name 'Manager Manager'
      manager_email 'manager@example.org'
      sequence(:manager_approval_token) {|n| n }
    end

    trait :created do
      state 'created'
    end
    trait :awaiting_manager_approval do
      state 'awaiting_manager_approval'
      manager_approval
    end
    trait :awaiting_assignment do
      state 'awaiting_assignment'
    end
    trait :assigned do
      state 'ready_for_review'
    end

    trait :approved do
      state 'approved'
      decision_body 'Welcome'
    end

    trait :rejected do
      state 'rejected'
      decision_body 'Sorry, no.'
    end

    factory :created_buyer_application, traits: [:created]
    factory :created_manager_approval_buyer_application, traits: [:created, :manager_approval]
    factory :awaiting_manager_approval_buyer_application, traits: [:awaiting_manager_approval, :with_completed_buyer_profile]
    factory :awaiting_assignment_buyer_application, traits: [:awaiting_assignment, :with_completed_buyer_profile]
    factory :assigned_buyer_application, traits: [:assigned, :with_completed_buyer_profile]
    factory :approved_buyer_application, traits: [:approved]
    factory :rejected_buyer_application, traits: [:rejected]
  end
end
