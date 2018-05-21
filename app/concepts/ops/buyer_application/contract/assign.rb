module Ops::BuyerApplication::Contract
  class Assign < Reform::Form
    include Forms::ValidationHelper

    model :buyer_application

    property :assigned_to_id

    validation :default, inherit: true do
      required(:assigned_to_id).filled(:int?, in_list?: ->{ User.admin.map(&:id) })
    end
  end
end
