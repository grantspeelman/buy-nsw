module Sellers::SellerApplication::Invitation::Contract
  class Accept < Reform::Form
    property :password
    property :password_confirmation, virtual: true

    validation :default do
      required(:password).filled
      required(:password_confirmation).filled
    end
  end
end
