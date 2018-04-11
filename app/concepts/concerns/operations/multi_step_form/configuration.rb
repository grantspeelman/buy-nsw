module Concerns::Operations::MultiStepForm
  class Configuration
    # This class allows for configuration definition within a multi-step form
    # operation.
    #
    # Example:
    #
    #  step_configuration do |options|
    #    i18n_key 'buyers.applications'
    #    params_key :buyer_application
    #
    #    model :application, options[:application_model]
    #    model :buyer, options[:buyer_model]
    #
    #    path_route :buyers_application_step_path, :application
    #  end
    #
    # In this case, the `options` argument is the operation result hash, which
    # will contain the operation state at the point in which this has been
    # invoked.
    #
    # (NOTE: This shouldn't be invoked before the step which looks up the model)
    #

    attr_reader :models

    def initialize(block, operation_result)
      @models = {}
      @config = {}

      @operation_result = operation_result

      self.instance_exec(operation_result, &block)
    end

    def model(key, object)
      @models[key] = object
    end

    def i18n_key(key)
      @config[:i18n_key] = key
    end

    def params_key(key)
      @config[:params_key] = key
    end

    def path_route(helper, model)
      @config[:path_helper] = helper
      @config[:path_model] = model
    end

    def get(key)
      @config.fetch(key)
    end

  private
    attr_reader :operation_result
  end
end
