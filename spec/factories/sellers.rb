FactoryBot.define do
  factory :seller do
    association :owner, factory: :user
    state 'inactive'
  end
end
