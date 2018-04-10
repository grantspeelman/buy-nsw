module Buyers::BuyerApplication::Contract
  class Base < Reform::Form
    include Concerns::Contracts::Composition
    include Concerns::Contracts::MultiStepForm
    include Concerns::Contracts::Status
    include Forms::ValidationHelper

    model :application
  end
end
