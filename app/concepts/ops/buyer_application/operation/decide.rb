class Ops::BuyerApplication::Decide < Trailblazer::Operation
  class Present < Trailblazer::Operation
    step Model( BuyerApplication, :find_by )
    step Contract::Build( constant: Ops::BuyerApplication::Contract::Decide )
  end

  step Nested(Present)
  step Contract::Validate( key: :buyer_application )
  step :validate_step_change
  step :set_timestamp
  step Contract::Persist()
  step :change_application_state
  step :notify_user_by_email

  def validate_step_change(options, model:, **)
    case options['contract.default'].decision
    when 'approve' then model.may_approve?
    when 'reject' then model.may_reject?
    end
  end

  def change_application_state(options, model:, **)
    case options['contract.default'].decision
    when 'approve' then model.approve!
    when 'reject' then model.reject!
    end
  end

  def notify_user_by_email(options, model:, **)
    mailer = BuyerApplicationMailer.with(application: model)
    case options['contract.default'].decision
    when 'approve' then mailer.application_approved_email.deliver_later
    when 'reject' then mailer.application_rejected_email.deliver_later
    end
  end

  def set_timestamp(options, model:, **)
    model.decided_at = Time.now
  end
end
