class Sellers::SellerApplication::Update < Trailblazer::Operation
  module Steps
    extend ActiveSupport::Concern
    include Concerns::Operations::MultiStepForm

    included do
      step_configuration do |options|
        i18n_key 'sellers.applications'
        params_key :seller_application

        model :application, options[:application_model]
        model :seller, options[:seller_model]

        path_route :sellers_application_step_path, :application
      end

      step_flow do |application, seller|
        step Sellers::SellerApplication::Contract::Introduction
        step Sellers::SellerApplication::Contract::BusinessDetails
        step Sellers::SellerApplication::Contract::BusinessInfo
        step Sellers::SellerApplication::Contract::Contacts
        step Sellers::SellerApplication::Contract::Disclosures
        step Sellers::SellerApplication::Contract::Documents
        step Sellers::SellerApplication::Contract::Recognition
        step Sellers::SellerApplication::Contract::Industry

        if seller.industry.any?
          step Sellers::SellerApplication::Contract::Services
          #
          # if seller.services.any?
          #   step Sellers::SellerApplication::Contract::Products
          # end
        end

        step Sellers::SellerApplication::Contract::Declaration
      end
    end
  end

  class Present < Trailblazer::Operation
    include Steps

    step :model!
    step :steps!
    step Contract::Build( builder: :build_contract_from_step! )

    success :prevalidate_if_started!
    success :set_submission_status!

    def model!(options, params:, **)
      options[:application_model] = SellerApplication.created.find_by_user_and_application(options['current_user'], params[:id])
      options[:seller_model] = options[:application_model].seller

      options[:application_model].present?
    end
  end

  include Steps
  step Nested(Present)

  # NOTE: We use the Validate method here to assign values, but we don't care
  # if they are invalid as we want the user to be able to return later to edit
  # the form. The full validation check is performed in the
  # `submit_if_valid_and_last_step!` step.
  #
  success Contract::Validate( key: :seller_application )

  # success :set_terms_agreed_at!
  step Contract::Persist()

  success :steps!
  success :next_step!

  success :submit_if_valid_and_last_step!

  # NOTE: Invoking this again at the end of the flow means that we can add
  # validation errors and show the form again when the fields are invalid.
  #
  step :prepopulate!
  step Contract::Validate()

  def submit_if_valid_and_last_step!(options, **)
    current_step = options['result.step']
    steps = options['result.steps']

    if (current_step == steps.last) && all_steps_valid?(options)
      options[:application_model].submit!
      options['result.submitted'] = true
    else
      options['result.submitted'] = false
    end
  end
end
