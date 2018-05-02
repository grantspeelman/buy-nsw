module Sellers::SellerApplication::Products::Contract
  class Basics < Base
    property :name, on: :product
    property :summary, on: :product
    property :audiences, on: :product

    property :section_text, writeable: false, on: :product

    validation :default do
      required(:product).schema do
        required(:name).filled
        required(:summary).filled
      end
    end

  end
end
