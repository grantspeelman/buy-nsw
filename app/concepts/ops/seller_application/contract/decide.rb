module Ops::SellerApplication::Contract
  class Decide < Reform::Form
    include Forms::ValidationHelper

    model :seller_application

    property :decision, virtual: true
    property :response

    validation :default, inherit: true do
      required(:decision).filled(in_list?: ['approve', 'reject', 'return_to_applicant'])
    end
  end
end
