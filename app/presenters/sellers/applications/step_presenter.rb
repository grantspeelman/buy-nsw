module Sellers::Applications
  class StepPresenter
    attr_reader :contract_class

    def initialize(contract_class)
      @contract_class ||= contract_class
    end

    def ==(other)
      contract_class == other.contract_class
    end

    def name(type = :short)
      base = "#{i18n_key}.steps.#{key}"

      I18n.t("#{base}.#{type}", default: I18n.t("#{base}.short"))
    end

    def button_label(default:)
      I18n.t("#{i18n_key}.steps.#{key}.button_label", default: default)
    end

    def i18n_key
      'sellers.applications'
    end

    def key
      contract_class.name.demodulize.underscore
    end

    def slug
      key.dasherize
    end

    def path(application:)
      Rails.application.routes.url_helpers.send(
        :sellers_application_step_path, id: application.id, step: slug
      )
    end

    def complete?(application, validate_optional_steps: false)
      contract = build_contract(application)

      if validate_optional_steps
        contract.valid?
      else
        contract.started? && contract.valid?
      end
    end

  private
    def build_contract(application)
      contract_class.new(
        application: application,
        seller: application.seller,
      )
    end
  end
end
