class SellerApplicationPresenter
  include Rails.application.routes.url_helpers

  attr_reader :current_step_key

  def initialize(application, current_step_key: nil)
    @application = application
    @current_step_key = current_step_key
  end

  def steps
    [
      Sellers::Applications::IntroductionForm,
      Sellers::Applications::BusinessDetailsForm,
      Sellers::Applications::BusinessInfoForm,
      Sellers::Applications::ContactsForm,
      Sellers::Applications::DisclosuresForm,
      Sellers::Applications::DocumentsForm,
      Sellers::Applications::MethodsForm,
      Sellers::Applications::RecognitionForm,
      Sellers::Applications::ServicesForm,
      Sellers::Applications::DeclarationForm,
    ]
  end

  ## Current steps

  def current_step
    get_step_from_key(current_step_key)
  end

  def current_step_form
    @form ||= current_step.new(application: application, seller: application.seller)
  end

  def current_step_name
    step_name(current_step, :long)
  end

  def current_step_view_path
    current_step.name.underscore
  end

  ## First and Next Steps

  def first_step_path
    step_path(steps.first)
  end

  def next_step
    next_step_key = steps.index(current_step) + 1
    steps[next_step_key] || steps.first
  end

  def next_step_path
    step_path(next_step)
  end

  ## Step helpers

  def step_path(step)
    sellers_application_step_path(
      application,
      step_key(step, format: :url)
    )
  end

  def step_name(step, type = :short)
    key = step_key(step)

    I18n.t("sellers.applications.steps.#{key}.#{type}")
  end

  def step_classes(step)
    classes = []

    if step == current_step
      classes << 'current'
    end

    classes.join(' ')
  end

private
  attr_reader :application

  def step_key(klass, format: nil)
    name = klass.name.demodulize.sub(/Form$/,'').underscore

    if format == :url
      name.dasherize
    else
      name
    end
  end

  def get_step_from_key(key)
    base = 'Sellers::Applications::'
    name = key.underscore.camelize + 'Form'

    (base + name).constantize
  end

end
