module Concerns::Operations::MultiStepForm::OperationSteps
  # All methods in this module are designed to be included as `steps` in a
  # Trailblazer::Operation object.
  #
  # They all must receive the current operation context (in the form of the
  # `options` hash)
  #
  # As a stylistic point, they are all 'bang!' methods, as returning false from
  # a step will cause the operation to fail.
  #

  def steps!(options, **)
    options['result.steps'] = build_steps_from_contracts(options)

  end

  def build_contract_from_step!(options, params:, **)
    steps = options['result.steps']

    slug = params.fetch(:step, nil)
    options['result.step'] = steps.find {|step| step.slug == slug } || steps.first
    options['result.last_step?'] = (options['result.step'] == steps.last)

    options['result.step'].contract
  end

  def prevalidate_if_started!(options, params:, **)
    contract = options['contract.default']
    config = build_configuration_from_contracts(options)
    params_key = config.get(:params_key)

    unless params.key?(params_key)
      contract.prepopulate!
      contract.validate(params.fetch(params_key, {})) if contract.started?
    end
  end

  def prepopulate!(options, **)
    contract = options['contract.default']
    contract.prepopulate!
  end

  def set_submission_status!(options, **)
    options['result.ready_for_submission'] =
      options['result.steps'][0...-1].reject {|step| step.started? && step.valid? }.empty?
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
end
