module Sellers::SellerApplication::Contract
  class Declaration < Base
    property :agree, on: :seller

    validation :default do
      required(:seller).schema do
        required(:agree).filled(:bool?, :true?)
      end
    end
  end
end
