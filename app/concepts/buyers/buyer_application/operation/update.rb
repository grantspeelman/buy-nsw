class Buyers::BuyerApplication::Update < Trailblazer::Operation
  module Steps
    extend ActiveSupport::Concern

    def steps!(options, **)
      options['result.steps'] = step_contracts(options).map {|contract|
        Buyers::BuyerApplication::Step.new(
          application: options[:application_model],
          buyer: options[:buyer_model],
          contract_class: contract,
        )
      }
    end

    def step_contracts(options)
      steps = []

      steps << Buyers::BuyerApplication::Contract::BasicDetails

      if options[:application_model].requires_email_approval?
        steps << Buyers::BuyerApplication::Contract::EmailApproval
      end

      steps << Buyers::BuyerApplication::Contract::EmploymentStatus

      if options[:application_model].requires_manager_approval?
        steps << Buyers::BuyerApplication::Contract::ManagerApproval
      end

      steps << Buyers::BuyerApplication::Contract::Terms

      steps
    end
  end

  class Buyers::BuyerApplication::Update::Present < Trailblazer::Operation
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

    def build_contract_from_step!(options, params:, **)
      slug = params.fetch(:step, nil)
      options['result.step'] =
        options['result.steps'].find {|step| step.slug == slug } || options['result.steps'].first

      options['result.step'].contract
    end

    def prevalidate_if_started!(options, params:, **)
      contract = options['contract.default']

      unless params.key?(:buyer_application)
        contract.validate(params.fetch(:buyer_application, {})) if contract.started?
      end
    end

    def set_submission_status!(options, **)
      options['result.ready_for_submission'] =
        options['result.steps'][0...-1].reject {|step| step.started? && step.valid? }.empty?
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

  success :set_terms_agreed_at!
  step Contract::Persist()

  success :steps!
  success :next_step!

  success :submit_if_valid_and_last_step!

  # NOTE: Invoking this again at the end of the flow means that we can add
  # validation errors and show the form again when the fields are invalid.
  #
  step Contract::Validate( key: :buyer_application )

  def set_terms_agreed_at!(options, **)
    return true unless options['result.step'].key == 'terms'

    form = options['contract.default']

    if form.terms_agreed == '1' && form.model[:buyer].terms_agreed.blank?
      form.terms_agreed_at = Time.now
    elsif !! form.terms_agreed
      form.terms_agreed_at = nil
    end
  end

  def next_step!(options, **)
    current_step = options['result.step']
    steps = options['result.steps']

    next_step_key = steps.index(current_step) + 1
    options['result.next_step_slug'] = steps[next_step_key]&.slug || steps.first.slug
  end

  def all_steps_valid?(options)
    options['result.steps'].reject(&:valid?).empty?
  end

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
