FactoryBot.define do
  factory :seller_application do
    association :owner, factory: :user
    association :seller

    state 'created'
  end
end
