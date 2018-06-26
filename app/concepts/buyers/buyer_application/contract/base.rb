module Buyers::BuyerApplication::Contract
  class Base < Reform::Form
    include Concerns::Contracts::Composition
    include Concerns::Contracts::MultiStepForm
    include Concerns::Contracts::Status
    include Forms::ValidationHelper

    model :application

    def i18n_base
      'buyers.applications.steps'
    end
  end
end
