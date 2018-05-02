module Sellers::SellerApplication::Products::Contract
  class Environment < Base
    property :name, on: :product
  end
end
