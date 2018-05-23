module Buyers::BuyerApplication::Contract
  class Terms < Base
    def valid?
      true
    end

    def started?
      false
    end
  end
end
