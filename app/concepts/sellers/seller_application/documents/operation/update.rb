class Sellers::SellerApplication::Documents::Update < Trailblazer::Operation
  module Steps
    extend ActiveSupport::Concern
    include Concerns::Operations::SellerApplicationForm

    included do
      step_configuration do |options|
        i18n_key 'sellers.applications.documents'
        params_key :seller_application

        model :application, options[:application_model]
        model :seller, options[:seller_model]

        path_route :documents_step_sellers_application_path, :application
      end

      step_flow do |application, seller|
        step Sellers::SellerApplication::Documents::Contract::Financials
        step Sellers::SellerApplication::Documents::Contract::ProfessionalIndemnity
        step Sellers::SellerApplication::Documents::Contract::WorkersCompensation
      end
    end
  end

  class Present < Trailblazer::Operation
    include Steps
  end

  include Steps
  include Concerns::Operations::SellerApplicationForm::Persist
end
