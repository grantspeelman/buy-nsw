module Sellers::SellerApplication::Products::Contract
  class Type < Base
    property :section, on: :product

    validation :default, inherit: true do
      required(:product).schema do
        required(:section).filled(in_list?: Product.section.values)
      end
    end
  end
end
