module Buyers::BuyerApplication::Contract
  class EmploymentStatus < Base
    property :employment_status, on: :buyer

    validation :default, inherit: true do
      required(:buyer).schema do
        required(:employment_status, in_list?: Buyer.employment_status.options).filled
      end
    end
  end
end
