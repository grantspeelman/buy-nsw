require_relative 'update/present'
require_relative 'update/steps'

class Buyers::BuyerApplication::Update < Trailblazer::Operation
  include Steps

  step Nested(Present)

  # NOTE: We use the Validate method here to assign values, but we don't care
  # if they are invalid as we want the user to be able to return later to edit
  # the form. The full validation check is performed in the
  # `submit_if_valid_and_last_step!` step.
  #
  success Contract::Validate( key: :buyer_application )

  success :set_terms_agreed_at!
  step Contract::Persist()

  success :steps!
  success :next_step!

  success :submit_if_valid_and_last_step!

  # NOTE: Invoking this again at the end of the flow means that we can add
  # validation errors and show the form again when the fields are invalid.
  #
  step Contract::Validate( key: :buyer_application )

  def set_terms_agreed_at!(options, **)
    return true unless options['result.step'].key == 'terms'

    form = options['contract.default']

    if form.terms_agreed == '1' && form.model[:buyer].terms_agreed.blank?
      form.terms_agreed_at = Time.now
    elsif !! form.terms_agreed
      form.terms_agreed_at = nil
    end
  end

  def next_step!(options, **)
    current_step = options['result.step']
    steps = options['result.steps']

    next_step_key = steps.index(current_step) + 1
    options['result.next_step_slug'] = steps[next_step_key]&.slug || steps.first.slug
  end

  def all_steps_valid?(options)
    options['result.steps'].reject(&:valid?).empty?
  end

  def submit_if_valid_and_last_step!(options, **)
    current_step = options['result.step']
    steps = options['result.steps']

    if (current_step == steps.last) && all_steps_valid?(options)
      options[:application_model].submit!
      options['result.submitted'] = true
    else
      options['result.submitted'] = false
    end
  end
end
