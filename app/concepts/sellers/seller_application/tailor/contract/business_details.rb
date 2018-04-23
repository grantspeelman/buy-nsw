module Sellers::SellerApplication::Tailor::Contract
  class BusinessDetails < Base
    property :name,         on: :seller
    property :abn,          on: :seller

    validation :default do
      required(:seller).schema do
        required(:name).filled
        required(:abn).filled
      end
    end
  end
end
