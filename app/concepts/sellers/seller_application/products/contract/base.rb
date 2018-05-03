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
  end
end
