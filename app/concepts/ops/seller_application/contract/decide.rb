module Ops::SellerApplication::Contract
  class Decide < Reform::Form
    property :decision, virtual: true
    property :response
  end
end
