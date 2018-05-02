module Sellers::SellerApplication::Products::Contract
  class AvailabilitySupport < Base
    property :name, on: :product
  end
end
