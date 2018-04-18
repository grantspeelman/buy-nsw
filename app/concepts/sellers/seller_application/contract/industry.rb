module Sellers::SellerApplication::Contract
  class Industry < Base
    property :industry, on: :seller

    validation :default, inherit: true do
      required(:seller).schema do
        required(:industry).value(any_checked?: true, one_of?: Seller.industry.values)
      end
    end
  end
end
