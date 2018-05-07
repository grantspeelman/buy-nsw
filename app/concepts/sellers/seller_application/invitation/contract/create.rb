module Sellers::SellerApplication::Invitation::Contract
  class Create < Reform::Form
    property :email

    validation :default do
      configure do
        predicates(Shared::Predicates)
      end

      required(:email).filled(:email?)
    end
  end
end
