module Sellers::SellerApplication::Products::Contract
  class Base < Reform::Form
    include Concerns::Contracts::Composition
    include Concerns::Contracts::MultiStepForm
    include Concerns::Contracts::Status
    include Forms::ValidationHelper

    model :product

    def product_id
      model[:product].id
    end

    def upload_for(key)
      self.model[:product].public_send(key)
    end

    def i18n_base
      'sellers.applications.products.steps'
    end
  end
end
