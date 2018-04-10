require_relative 'steps'

class Buyers::BuyerApplication::Update::Present < Trailblazer::Operation
  include Buyers::BuyerApplication::Update::Steps

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
