class Ops::SellerVersion::Decide < Trailblazer::Operation
  class Present < Trailblazer::Operation
    step Model( SellerVersion, :find_by )
    step Contract::Build( constant: Ops::SellerVersion::Contract::Decide )
  end

  class WithTransaction
    extend Uber::Callable

    def self.call((ctx, flow_options), *, &block)
      begin
        ActiveRecord::Base.transaction { yield }
      rescue
        [ Trailblazer::Operation::Railway.fail!, [ctx, flow_options] ]
      end
    end
  end

  step Nested(Present)
  step Contract::Validate( key: :seller_application )
  step :validate_step_change
  step :set_timestamp
  step Contract::Persist()
  step :change_application_state
  step :log_event
  step :notify_owner_by_email

  def validate_step_change(options, model:, **)
    case options['contract.default'].decision
    when 'approve' then model.may_approve?
    when 'reject' then model.may_reject?
    when 'return_to_applicant' then model.may_return_to_applicant?
    end
  end

  def change_application_state(options, model:, **)
    case options['contract.default'].decision
    when 'approve' then model.approve!
    when 'reject' then model.reject!
    when 'return_to_applicant' then model.return_to_applicant!
    end
  end

  def log_event(options, model:, **)
    params = {
      user: options['current_user'],
      eventable: model,
      note: options['contract.default'].response,
    }
    case options['contract.default'].decision
    when 'approve' then Event::ApprovedApplication.create(params)
    when 'reject' then Event::RejectedApplication.create(params)
    when 'return_to_applicant' then Event::ReturnedApplication.create(params)
    end
  end

  def notify_owner_by_email(options, model:, **)
    mailer = SellerApplicationMailer.with(application: model)
    case options['contract.default'].decision
    when 'approve'
      mailer.application_approved_email.deliver_later
    when 'reject'
      mailer.application_rejected_email.deliver_later
    when 'return_to_applicant'
      mailer.application_return_to_applicant_email.deliver_later
    end
  end

  def set_timestamp(options, model:, **)
    model.decided_at = Time.now
  end
end
