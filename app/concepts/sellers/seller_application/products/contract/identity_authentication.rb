module Sellers::SellerApplication::Products::Contract
  class IdentityAuthentication < Base
    property :name, on: :product
  end
end
