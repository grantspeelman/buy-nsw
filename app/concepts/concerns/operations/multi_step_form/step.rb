module Concerns::Operations::MultiStepForm
  class Step
    attr_reader :contract, :contract_class

    def initialize(config:, contract_class:)
      @config = config
      @contract_class ||= contract_class
      @contract ||= build_contract
    end

    def ==(other)
      contract_class == other.contract_class
    end

    def name(type = :short)
      I18n.t("#{i18n_key}.steps.#{key}.#{type}")
    end

    def button_label(default:)
      I18n.t("#{i18n_key}.steps.#{key}.button_label", default: default)
    end

    def key
      contract_class.name.demodulize.underscore
    end

    def slug
      key.dasherize
    end

    def path
      # NOTE: Use the models defined in the step configuration as arguments for the
      # URL helper. This selects them in the order they were defined.
      #
      resources = models.slice(*config.get(:path_models)).values

      Rails.application.routes.url_helpers.send(
        config.get(:path_helper), *resources, slug
      )
    end

    def valid?
      # NOTE: we build a new contract here to avoid running validations over
      # the existing contract, which would then be displayed to the user (in
      # addition to the regular validations)
      #
      build_contract.valid?
    end

    def required_fields_to_complete
      # NOTE: We need to create empty copies of the models here so that we can create
      # a brand new form without any data included.
      #
      empty_models = Hash[models.map {|key, object|
        [key, object.class.new]
      }]
      empty_contract = contract_class.new(**empty_models)
      empty_contract.valid?

      empty_contract.errors.messages.size
    end

    def required_fields_completed
      # NOTE: we build a new contract here to avoid running validations over
      # the existing contract, which would then be displayed to the user (in
      # addition to the regular validations)
      #
      completed_contract = build_contract
      completed_contract.valid?
      contract_errors = completed_contract.errors.messages.size

      required_fields_to_complete - contract_errors
    end

    def html_classes
      case
      when (started? && valid?) then 'complete'
      when started? then 'started'
      else
        ''
      end
    end

    def started?
      contract.started?
    end

  private
    attr_reader :config

    def build_contract
      contract_class.new(**models)
    end

    def models
      config.models
    end

    def i18n_key
      config.get(:i18n_key)
    end
  end
end
