module Buyers::BuyerApplication::Contract
  class BasicDetails < Base
    property :name, on: :buyer
    property :organisation, on: :buyer

    validation :default do
      required(:buyer).schema do
        required(:name).filled
        required(:organisation).filled
      end
    end
  end
end
