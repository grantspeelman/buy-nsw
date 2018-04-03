module Ops::SellerApplication::Contract
  class Assign < Reform::Form
    model :seller_application

    property :assigned_to_id
  end
end
