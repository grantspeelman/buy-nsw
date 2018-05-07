module Sellers::SellerApplication::Invitation::Contract
  class Create < Reform::Form
    include Forms::ValidationHelper

    property :email

    validation :default, inherit: true do
      required(:email).filled(:email?)
    end
  end
end
