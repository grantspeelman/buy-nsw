class Buyers::BuyerApplication::Update < Trailblazer::Operation
  module Steps
    extend ActiveSupport::Concern
    include Concerns::Operations::MultiStepForm

    included do
      step_configuration do |options|
        i18n_key 'buyers.applications'
        params_key :buyer_application

        model :application, options[:application_model]
        model :buyer, options[:buyer_model]

        path_route :buyers_application_step_path, :application
      end

      step_flow do |application, buyer|
        step Buyers::BuyerApplication::Contract::BasicDetails

        if application.requires_email_approval?
          step Buyers::BuyerApplication::Contract::EmailApproval
        end

        step Buyers::BuyerApplication::Contract::EmploymentStatus

        if application.requires_manager_approval?
          step Buyers::BuyerApplication::Contract::ManagerApproval
        end

        step Buyers::BuyerApplication::Contract::Terms
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
      options[:application_model] = BuyerApplication.created.find_by_user_and_application(options['current_user'], params[:id])
      options[:buyer_model] = options[:application_model].buyer

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
  success Contract::Validate( key: :buyer_application )

  step Contract::Persist()

  success :steps!
  success :next_step!

  success :submit_if_valid_and_last_step!
  success :log_event!
  success :send_slack_notification!

  # NOTE: Invoking this again at the end of the flow means that we can add
  # validation errors and show the form again when the fields are invalid.
  #
  step Contract::Validate( key: :buyer_application )

  def submit_if_valid_and_last_step!(options, **)
    current_step = options['result.step']
    steps = options['result.steps']

    if (current_step == steps.last) && all_steps_valid?(options)
      options[:application_model].submit!
      options['result.submitted'] = true

      if options[:application_model].state == 'awaiting_manager_approval'
        send_manager_approval_email!(options[:application_model])
      end
    else
      options['result.submitted'] = false
    end
  end

  def log_event!(options, **)
    if options['result.submitted']
      Event::SubmittedApplication.create(
        user: options['current_user'],
        eventable: options[:application_model]
      )
    end
  end

  def send_slack_notification!(options, **)
    if options['result.submitted']
      SlackPostJob.perform_later(
        options[:application_model].id,
        :buyer_application_submitted.to_s
      )
    end
  end

  def send_manager_approval_email!(application)
    application.set_manager_approval_token!
    BuyerApplicationMailer.with(application: application).manager_approval_email.deliver_later
  end
end
