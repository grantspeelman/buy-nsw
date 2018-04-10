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

  def set_timestamp(options, model:, **)
    model.decided_at = Time.now
  end
end
