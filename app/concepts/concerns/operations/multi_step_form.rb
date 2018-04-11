module Concerns::Operations::MultiStepForm
  extend ActiveSupport::Concern

  included do
    include OperationSteps

    def self.step_flow(&block)
      @@step_contract_block = block
    end

    def self.step_configuration(&block)
      @@step_configuration_block = block
    end
  end

  def build_configuration_from_contracts(operation_result)
    @configuration ||= Configuration.new(@@step_configuration_block, operation_result)
  end

  def build_steps_from_contracts(operation_result)
    Builder.new(
      @@step_contract_block,
      operation_result: operation_result,
      config: build_configuration_from_contracts(operation_result),
    ).steps
  end
end
