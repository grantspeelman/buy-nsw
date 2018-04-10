module Ops::BuyerApplication::Contract
  class Assign < Reform::Form
    model :buyer_application

    property :assigned_to_id

    validation :default do
      required(:assigned_to_id).filled(:int?)
    end
  end
end
