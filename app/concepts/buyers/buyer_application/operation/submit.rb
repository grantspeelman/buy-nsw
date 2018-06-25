class Buyers::BuyerApplication::Submit < Trailblazer::Operation
  class Present < Trailblazer::Operation
    success :build_all_contracts!
    success :set_submission_status!

    def build_all_contracts!(options, **)
      options['result.contracts'] = options['config.form'].contracts.map {|contract|
        contract.new(
          application: options['model.application'],
          buyer: options['model.buyer'],
        )
      }
    end

    def set_submission_status!(options, **)
      options['result.ready_for_submission'] =
        options['result.contracts'][0...-1].reject(&:valid?).empty?
    end
  end

  step Nested(Present)
  step :ensure_all_steps_valid!, fail_fast: true
  step :submit_application!
  step :send_manager_approval_email!
  success :log_event!
  success :send_slack_notification!

  def ensure_all_steps_valid!(options, **)
    options['result.contracts'].reject(&:valid?).empty?
  end

  def submit_application!(options, **)
    options['model.application'].submit!
    options['result.submitted'] = true
  end

  def log_event!(options, **)
    Event::SubmittedApplication.create(
      user: options['config.current_user'],
      eventable: options['model.application']
    )
  end

  def send_slack_notification!(options, **)
    SlackPostJob.perform_later(
      options['model.application'].id,
      :buyer_application_submitted.to_s
    )
  end

  def send_manager_approval_email!(options, **)
    application = options['model.application']

    if application.state == 'awaiting_manager_approval'
      application.set_manager_approval_token!
      BuyerApplicationMailer.with(application: application).manager_approval_email.deliver_later
    end
  end
end
