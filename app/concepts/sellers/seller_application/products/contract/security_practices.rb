module Sellers::SellerApplication::Products::Contract
  class SecurityPractices < Base
    property :secure_development_approach, on: :product
    property :penetration_testing_frequency, on: :product
    property :penetration_testing_approach, on: :product

    validation :default, inherit: true do
      required(:product).schema do
        required(:secure_development_approach).filled(in_list?: Product.secure_development_approach.values)
        required(:penetration_testing_frequency).filled(in_list?: Product.penetration_testing_frequency.values)
        required(:penetration_testing_approach).filled(in_list?: Product.penetration_testing_approach.values)
      end
    end
  end
end
