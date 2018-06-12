FactoryBot.define do
  factory :seller_address do
    association :seller
    
    address '123 Test Street'
    suburb 'Sydney'
    state 'nsw'
    postcode '2000'
    country 'AU'
  end
end
