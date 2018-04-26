class Sellers::SellerApplication::Products::Update < Trailblazer::Operation
  module Steps
    extend ActiveSupport::Concern
    include Concerns::Operations::MultiStepForm

    included do
      step_configuration do |options|
        i18n_key 'sellers.applications.products'
        params_key :seller_application

        model :application, options[:application_model]
        model :seller, options[:seller_model]
        model :product, options[:product_model]

        path_route :sellers_application_product_step_path, :application, :product
      end

      step_flow do |application, seller, product|
        step Sellers::SellerApplication::Products::Contract::Basics
      end
    end
  end

  class Present < Trailblazer::Operation
    include Steps

    step :model!
    step :steps!
    step Contract::Build( builder: :build_contract_from_step! )

    success :prevalidate_if_started!

    def model!(options, params:, **)
      options[:application_model] = options['current_user'].seller_applications.find(params[:application_id])
      options[:seller_model] = options[:application_model].seller
      options[:product_model] = options[:seller_model].products.find(params[:id])

      options[:product_model].present?
    end
  end

  include Steps
  step Nested(Present)

  include Concerns::Operations::SellerApplicationForm::Persist
end
