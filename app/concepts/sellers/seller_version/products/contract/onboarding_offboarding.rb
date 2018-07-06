module Sellers::SellerVersion::Products::Contract
  class OnboardingOffboarding < Base
    property :onboarding_assistance, on: :product
    property :offboarding_assistance, on: :product

    validation :default, inherit: true do
      required(:product).schema do
        required(:onboarding_assistance).filled(max_word_count?: 200)
        required(:offboarding_assistance).filled(max_word_count?: 200)
      end
    end
  end
end
