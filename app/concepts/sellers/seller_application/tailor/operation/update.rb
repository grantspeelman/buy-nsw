class Sellers::SellerApplication::Tailor::Update < Trailblazer::Operation
  module Steps
    extend ActiveSupport::Concern
    include Concerns::Operations::MultiStepForm

    included do
      step_configuration do |options|
        i18n_key 'sellers.applications.tailor'
        params_key :seller_application

        model :application, options[:application_model]
        model :seller, options[:seller_model]

        path_route :tailor_step_sellers_application_path, :application
      end

      step_flow do |application, seller|
        step Sellers::SellerApplication::Tailor::Contract::Introduction
        step Sellers::SellerApplication::Tailor::Contract::BusinessDetails
        step Sellers::SellerApplication::Tailor::Contract::Industry

        if seller.industry.include?(:ict)
          step Sellers::SellerApplication::Tailor::Contract::Services
        end

        step Sellers::SellerApplication::Tailor::Contract::Review
      end
    end
  end

  class Present < Trailblazer::Operation
    include Steps
    include Concerns::Operations::SellerApplicationForm

    success :set_submission_status!
  end

  include Steps
  step Nested(Present)

  # NOTE: We use the Validate method here to assign values, but we don't care
  # if they are invalid as we want the user to be able to return later to edit
  # the form.
  #
  success Contract::Validate( key: :seller_application )

  step Contract::Persist()

  success :steps!
  success :next_step!

  success :complete_if_valid_and_last_step!

  # NOTE: Invoking this again at the end of the flow means that we can add
  # validation errors and show the form again when the fields are invalid.
  #
  step :prepopulate!
  step Contract::Validate()
end
