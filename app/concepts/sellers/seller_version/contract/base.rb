module Sellers::SellerVersion::Contract
  class Base < Reform::Form
    include Concerns::Contracts::Composition
    include Concerns::Contracts::MultiStepForm
    include Concerns::Contracts::Status
    include Concerns::Contracts::SellerApplication
    include Forms::ValidationHelper

    def upload_for(key)
      self.model[:seller].public_send(key)
    end

    def i18n_base
      'sellers.applications.steps'
    end
  end
end
