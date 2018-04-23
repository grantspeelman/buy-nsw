module Concerns::Operations::SellerApplicationForm
  extend ActiveSupport::Concern

  included do
    include Concerns::Operations::MultiStepForm

    step :model!
    step :steps!
    step Trailblazer::Operation::Contract::Build( builder: :build_contract_from_step! )

    success :prevalidate_if_started!
    success :set_validation_status!
  end

  def model!(options, params:, **)
    options[:application_model] ||= SellerApplication.created.find_by_user_and_application(options['current_user'], params[:id])
    options[:seller_model] = options[:application_model].seller

    options[:application_model].present?
  end

  def set_validation_status!(options, **)
    options['result.valid?'] = all_steps_valid?(options)
    options['result.percent_complete'] = calculate_completion_rate(options)
  end

  def calculate_completion_rate(options)
    steps = options['result.steps']

    required_fields_to_complete = steps.map(&:required_fields_to_complete).inject(&:+).to_f
    required_fields_completed = steps.map(&:required_fields_completed).inject(&:+).to_f

    return 100 if required_fields_to_complete == 0

    (required_fields_completed / required_fields_to_complete * 100).round
  end
end
