module Sellers::SellerApplication::Contract
  class Review < Base
    def valid?
      true
    end

    def started?
      false
    end
  end
end
