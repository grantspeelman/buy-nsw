module Buyers::BuyerApplication::Contract
  class ManagerApproval < Base
    property :manager_name, on: :application
    property :manager_email, on: :application

    validation :default do
      required(:application).schema do
        required(:manager_name).filled
        required(:manager_email).filled
      end
    end
  end
end
