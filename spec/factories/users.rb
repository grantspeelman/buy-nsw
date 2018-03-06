FactoryBot.define do
  factory :user do
    sequence(:email) {|n| "user-#{n}@example.org" }
    password '12345678'
    confirmed_at 1.day.ago
  end
end
