FactoryBot.define do
  factory :seller_accreditation do
    sequence(:accreditation) {|n| "ISO#{27000+n} compliance" }
    seller
  end
end
