module Sellers::SellerApplication::Invitation::Contract
  class Create < Reform::Form
    property :email

    validation :default do
      required(:email).filled
    end
  end
end
