module Sellers::SellerApplication::Contract::Products
  class Info < Base
    model :product

    property :name
    property :summary
    property :section
    property :audiences

    property :section_text, writeable: false

    validation :default do
      required(:name).filled
      required(:summary).filled
    end

  end
end
