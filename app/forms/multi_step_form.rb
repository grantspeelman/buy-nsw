class MultiStepForm
  include MultiStepForm::Navigation
  include MultiStepForm::Validation

  attr_reader :contracts_block, :contracts_args, :step, :i18n_key

  def initialize(contracts_block:, contracts_args:, i18n_key:, step: nil)
    @contracts_block = contracts_block
    @contracts_args = contracts_args
    @step = step
    @i18n_key = i18n_key
  end

  def contracts
    contracts_block.call(*contracts_args.map(&:reload))
  end

  def current_step
    @current_step ||= contracts.find {|contract|
      StepPresenter.new(contract, i18n_key: i18n_key).slug == step
    } || first_step
  end

  def current_step_presenter
    StepPresenter.new(current_step, i18n_key: i18n_key)
  end



end
