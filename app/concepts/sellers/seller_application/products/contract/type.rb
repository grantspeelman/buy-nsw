module Sellers::SellerApplication::Products::Contract
  class Type < Base
    property :section, on: :product
  end
end
