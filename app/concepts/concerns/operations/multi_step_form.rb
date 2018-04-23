module Concerns::Operations::MultiStepForm
  extend ActiveSupport::Concern

  included do
    include OperationSteps
    mattr_accessor :step_contract_block, :step_configuration_block
  end

  class_methods do
    def step_flow(&block)
      self.step_contract_block = block
    end

    def step_configuration(&block)
      self.step_configuration_block = block
    end
  end

  def build_configuration_from_contracts(operation_result)
    @configuration ||= Configuration.new(self.step_configuration_block, operation_result)
  end

  def build_steps_from_contracts(operation_result)
    Builder.new(
      self.step_contract_block,
      operation_result: operation_result,
      config: build_configuration_from_contracts(operation_result),
    ).steps
  end
end
