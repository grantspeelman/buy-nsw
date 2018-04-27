class Sellers::SellerApplication::Submit < Trailblazer::Operation
  class Present < Trailblazer::Operation
    step :model!

    def model!(options, params:, **)
      options['model'] = options['current_user'].seller_applications.find(params[:id])
    end
  end

  step Nested(Present)
  step :validate_step_change!
  step :set_timestamp!
  step :change_application_state!
  step :persist!
  step :log_event!

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
      user: options['current_user'],
      eventable: model
    )
  end
end
