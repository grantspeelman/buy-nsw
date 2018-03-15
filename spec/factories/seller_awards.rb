FactoryBot.define do
  factory :seller_award do
    sequence(:award) {|n| "Baker of the year #{2010+n}" }
    seller
  end
end
