class Buyers::BuyerApplication::Update < Trailblazer::Operation
  class Present < Trailblazer::Operation
    step :model!
    step :contract!
    success :prepare_for_submission!

    def model!(options, params:, **)
      options['model.buyer'] = options['model.application'].buyer
      options['model.application'].present?
    end

    def contract!(options, **)
      options['contract.default'] = options['config.form'].current_step.new(
        application: options['model.application'],
        buyer: options['model.buyer'],
      )
    end

    def prepare_for_submission!(options, **)
      operation = Buyers::BuyerApplication::Submit::Present.({}, options.to_hash.stringify_keys)
      options['result.ready_for_submission'] = operation['result.ready_for_submission']
      options['result.submitted'] = false
    end
  end

  step Nested(Present)

  # NOTE: We use the Validate method here to assign values, but we don't care
  # if they are invalid as we want the user to be able to return later to edit
  # the form. The full validation check is performed in the
  # `submit_if_valid_and_last_step!` step.
  #
  success Contract::Validate( key: :buyer_application )
  step Contract::Persist()

  success :submit_if_last_step!

  # NOTE: Invoking this again at the end of the flow means that we can add
  # validation errors and show the form again when the fields are invalid.
  #
  step Contract::Validate( key: :buyer_application )

  def submit_if_last_step!(options, **)
    if options['config.form'].last_step?
      submit = Buyers::BuyerApplication::Submit.({}, options.to_hash.stringify_keys)
      options['result.submitted'] = submit['result.submitted']
    end
  end

end
