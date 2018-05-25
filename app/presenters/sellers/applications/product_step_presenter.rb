module Sellers::Applications
  class ProductStepPresenter < StepPresenter
    def i18n_key
      'sellers.applications.products'
    end

    def path(application:, product:)
      Rails.application.routes.url_helpers.send(
        :sellers_application_product_step_path, id: product.id, application_id: application.id, step: slug
      )
    end

    def complete?(application, product, validate_optional_steps: false)
      contract = build_contract(application, product)

      if validate_optional_steps
        contract.valid?
      else
        contract.started? && contract.valid?
      end
    end

  private
    def build_contract(application, product)
      contract_class.new(
        application: application,
        seller: application.seller,
        product: product,
      )
    end
  end
end
