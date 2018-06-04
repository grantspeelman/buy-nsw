FactoryBot.define do
  factory :problem_report do
    task 'try to do something'
    issue 'it does not work'
    browser 'ExampleBrowser 5/1.2.3'
    url 'http://example.org/cloud'
    referer 'http://example.org/referer'
    tags ['test']
    association :user

    trait :open do
      state 'open'
    end

    trait :resolved do
      state 'resolved'
      resolved_at { 1.hour.ago }
      association :resolved_by, factory: :user
    end

    factory :open_problem_report, traits: [:open]
    factory :resolved_problem_report, traits: [:resolved]
  end
end
