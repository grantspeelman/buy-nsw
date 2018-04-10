module Buyers::BuyerApplication::Contract
  class Terms < Base
    property :terms_agreed, on: :buyer
    property :terms_agreed_at, on: :buyer, parse: false

    validation :default do
      required(:buyer).schema do
        required(:terms_agreed).filled(:bool?, :true?)
      end
    end
  end
end
