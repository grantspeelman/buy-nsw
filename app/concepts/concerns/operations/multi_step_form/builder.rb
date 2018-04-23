module Concerns::Operations::MultiStepForm
  class Builder
    # This class defines the steps and order for a multi-step form operation.
    #
    # Example:
    #
    #   step_flow do |application, buyer|
    #     step Buyers::BuyerApplication::Contract::BasicDetails
    #
    #     if application.requires_email_approval?
    #       step Buyers::BuyerApplication::Contract::EmailApproval
    #     end
    #   end
    #
    # Steps are executed in the order defined. The block receives models in
    # order of their definition in the `step_configuration`.
    #
    # Each step should include a Contract form object, which will be then
    # built automatically.
    #

    attr_reader :contracts, :operation_result, :config

    def initialize(block, operation_result:, config:)
      @operation_result = operation_result
      @config = config

      @contracts = []

      self.instance_exec(*model_args, &block)
    end

    def step(contract)
      @contracts << contract
    end

    def steps
      contracts.map {|contract|
        Step.new(
          config: config,
          contract_class: contract,
        )
      }
    end

    def model_args
      config.models.map {|key, object|
        object.reload
      }
    end
  end
end
