class Ops::SellerApplication::Assign < Trailblazer::Operation
  class Present < Trailblazer::Operation
    step Model( SellerApplication, :find_by )
    step Contract::Build( constant: Ops::SellerApplication::Contract::Assign )
  end

  step Nested(Present)
  step Contract::Validate( key: :seller_application )
  step Contract::Persist()
  step :change_application_state

  def change_application_state(options, model:, **)
    model.assign if model.may_assign?
    true
  end
end
