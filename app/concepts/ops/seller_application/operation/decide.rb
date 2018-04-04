class Ops::SellerApplication::Decide < Trailblazer::Operation
  class Present < Trailblazer::Operation
    step Model( SellerApplication, :find_by )
    step Contract::Build( constant: Ops::SellerApplication::Contract::Decide )
  end

  step Nested(Present)
  step Contract::Validate( key: :seller_application )
  step :set_timestamp
  step Contract::Persist()
  step :change_application_state

  def change_application_state(options, model:, **)
    case options['contract.default'].decision
    when 'approve' then model.approve!
    when 'reject' then model.reject!
    when 'return_to_applicant' then model.return_to_applicant!
    end
  end

  def set_timestamp(options, model:, **)
    model.decided_at = Time.now
  end
end
