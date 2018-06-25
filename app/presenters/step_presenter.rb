class StepPresenter
  attr_reader :contract_class, :i18n_key

  def initialize(contract_class, i18n_key:)
    @contract_class ||= contract_class
    @i18n_key ||= i18n_key
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
end
