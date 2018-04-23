module Sellers::SellerApplication::Tailor::Contract
  class Review < Base
    def valid?
      true
    end

    def started?
      false
    end
  end
end
