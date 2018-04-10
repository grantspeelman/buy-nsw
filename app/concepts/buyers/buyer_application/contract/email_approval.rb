module Buyers::BuyerApplication::Contract
  class EmailApproval < Base
    property :application_body, on: :application

    validation :default do
      required(:application).schema do
        required(:application_body).filled
      end
    end
  end
end
