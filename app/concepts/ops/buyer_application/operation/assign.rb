class Ops::BuyerApplication::Assign < Trailblazer::Operation
  class Present < Trailblazer::Operation
    step Model( BuyerApplication, :find_by )
    step Contract::Build( constant: Ops::BuyerApplication::Contract::Assign )
  end

  step Nested(Present)
  step Contract::Validate( key: :buyer_application )
  success :change_application_state
  step Contract::Persist()

  def change_application_state(options, model:, **)
    if model.may_assign?
      model.assign
    end
  end
end
