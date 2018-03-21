class SellerApplicationStepPresenter
  include Rails.application.routes.url_helpers

  class NotFound < StandardError; end

  attr_reader :form_klass

  def initialize(application, form_klass)
    @application ||= application
    @form_klass ||= form_klass
  end

  def self.forms(application)
    forms = []

    forms << Sellers::Applications::IntroductionForm
    forms << Sellers::Applications::BusinessDetailsForm
    forms << Sellers::Applications::BusinessInfoForm
    forms << Sellers::Applications::ContactsForm
    forms << Sellers::Applications::DisclosuresForm
    forms << Sellers::Applications::DocumentsForm
    forms << Sellers::Applications::RecognitionForm
    forms << Sellers::Applications::IndustryForm

    if application.seller.industry.any?
      forms << Sellers::Applications::ServicesForm

      if application.seller.services.any?
        forms << Sellers::Applications::ProductsForm
      end
    end

    forms << Sellers::Applications::DeclarationForm

    forms
  end

  def self.steps(application)
    forms(application).map {|form|
      self.new(application, form)
    }
  end

  def self.find_by_key(application, key)
    steps(application).find {|step| step.key == key }
  end

  def self.find_by_slug(application, slug)
    steps(application).find {|step| step.slug == slug } || raise(NotFound, slug)
  end

  def ==(other)
    form_klass == other.form_klass
  end

  def form
    @form ||= form_klass.new(
      application: application,
      seller: application.seller,
    )
  end

  def key
    form_klass.name.demodulize.sub(/Form$/,'').underscore
  end

  def slug
    key.dasherize
  end

  def path
    sellers_application_step_path(application, slug)
  end

  def name(type = :short)
    I18n.t("sellers.applications.steps.#{key}.#{type}")
  end

  def button_label(default:)
    I18n.t("sellers.applications.steps.#{key}.button_label", default: default)
  end

  def html_classes
    case
    when (started? && valid?) then 'complete'
    when started? then 'started'
    else
      ''
    end
  end

  def valid?
    form.valid?
  end

  def started?
    form.started?
  end

private
  attr_reader :application
end
