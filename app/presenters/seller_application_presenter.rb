class SellerApplicationPresenter
  # include Rails.application.routes.url_helpers

  attr_reader :current_step, :current_step_slug

  def initialize(application, current_step_slug: nil)
    @application = application
    @current_step_slug = current_step_slug

    @current_step = current_step_slug ? get_step_from_slug(current_step_slug) : steps.first
  end

  def steps
    SellerApplicationStepPresenter.steps(application)
  end

  ## Current steps

  def current_step_form
    @form ||= current_step.form
  end

  def current_step_name
    current_step.name(:long)
  end

  def current_step_key
    current_step.key
  end

  def current_step_view_path
    current_step.key + "_form"
  end

  def current_step_button_label(default:)
    current_step.button_label(default: default)
  end

  ## First and Next Steps

  def first_step_path
    steps.first.path
  end

  def last_step?
    current_step == steps.last
  end

  def next_step
    next_step_key = steps.index(current_step) + 1
    steps[next_step_key] || steps.first
  end

  def next_step_path
    next_step.path
  end

  ## Step helpers

  def html_classes(step)
    current_state = (step == current_step) ? 'current' : ''

    [ step.html_classes, current_state ].join(' ')
  end

private
  attr_reader :application

  def get_step_from_slug(slug)
    SellerApplicationStepPresenter.find_by_slug(application, slug)
  end

end
