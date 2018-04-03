module Ops::SellerApplication::Contract
  class Decide < Reform::Form
    model :seller_application

    property :decision, virtual: true
    property :response
  end
end
