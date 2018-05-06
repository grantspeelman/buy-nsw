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
        step Sellers::SellerApplication::Products::Contract::Type
        step Sellers::SellerApplication::Products::Contract::Basics
        step Sellers::SellerApplication::Products::Contract::Commercials
        step Sellers::SellerApplication::Products::Contract::OnboardingOffboarding
        step Sellers::SellerApplication::Products::Contract::Environment
        step Sellers::SellerApplication::Products::Contract::AvailabilitySupport
        step Sellers::SellerApplication::Products::Contract::UserData
        step Sellers::SellerApplication::Products::Contract::IdentityAuthentication
        step Sellers::SellerApplication::Products::Contract::SecurityStandards
        step Sellers::SellerApplication::Products::Contract::SecurityPractices
        step Sellers::SellerApplication::Products::Contract::OperationalSecurity
        step Sellers::SellerApplication::Products::Contract::ReportingAnalytics
        step Sellers::SellerApplication::Products::Contract::Review
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

  success :complete_if_last_step!

  include Concerns::Operations::SellerApplicationForm::Persist
end
