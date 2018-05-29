module Sellers::SellerApplication::Products::Contract
  class Terms < Base
    property :terms_file, on: :product
  end
end
