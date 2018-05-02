module Sellers::SellerApplication::Products::Contract
  class UserData < Base
    property :name, on: :product
  end
end
