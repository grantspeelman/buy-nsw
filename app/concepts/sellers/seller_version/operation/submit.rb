class Sellers::SellerVersion::Submit < Trailblazer::Operation
  class Present < Trailblazer::Operation
    step :model!
    step :ensure_complete!

    def model!(options, params:, **)
      options['model'] = options['config.current_user'].seller_versions.find(params[:id])
    end

    def ensure_complete!(options, **)
      options['result.progress'] = SellerApplicationProgressReport.new(
        application: options['model'],
        base_steps: Sellers::Applications::StepsController.steps(options['model']),
        product_steps: Sellers::Applications::ProductsController.steps,
        validate_optional_steps: true,
      )

      options['result.progress'].all_steps_valid?
    end
  end

  step Nested(Present)
  step :validate_step_change!
  step :set_timestamp!
  step :change_application_state!
  step :persist!
  step :log_event!
  step :send_slack_notification!

  def validate_step_change!(options, model:, **)
    model.may_submit?
  end

  def change_application_state!(options, model:, **)
    model.submit
  end

  def set_timestamp!(options, model:, **)
    model.submitted_at = Time.now
  end

  def persist!(options, model:, **)
    model.save
  end

  def log_event!(options, model:, **)
    Event::SubmittedApplication.create(
      user: options['config.current_user'],
      eventable: model
    )
  end

  def send_slack_notification!(options, model:, **)
    SlackPostJob.perform_later(
      model.id,
      :seller_version_submitted.to_s
    )
  end
end
