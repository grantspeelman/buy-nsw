class Buyers::BuyerApplication::Step
  include Rails.application.routes.url_helpers
  attr_reader :contract, :contract_class

  def initialize(application:, buyer:, contract_class:)
    @application ||= application
    @buyer ||= buyer

    @contract_class ||= contract_class
    @contract ||= build_contract
  end

  def ==(other)
    contract_class == other.contract_class
  end

  def name(type = :short)
    I18n.t("buyers.applications.steps.#{key}.#{type}")
  end

  def key
    contract_class.name.demodulize.underscore
  end

  def slug
    key.dasherize
  end

  def path
    buyers_application_step_path(application, slug)
  end

  def valid?
    # NOTE: we build a new contract here to avoid running validations over
    # the existing contract, which would then be displayed to the user (in
    # addition to the regular validations)
    #
    build_contract.valid?
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
  attr_reader :application, :buyer

  def build_contract
    contract_class.new(
      application: application,
      buyer: buyer,
    )
  end
end
