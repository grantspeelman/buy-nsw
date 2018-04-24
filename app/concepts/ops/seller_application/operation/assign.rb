class Ops::SellerApplication::Assign < Trailblazer::Operation
  class Present < Trailblazer::Operation
    step Model( SellerApplication, :find_by )
    step Contract::Build( constant: Ops::SellerApplication::Contract::Assign )
  end

  step Nested(Present)
  step Contract::Validate( key: :seller_application )
  step :change_application_state
  step Contract::Persist()
  step :log_event

  def change_application_state(options, model:, **)
    if model.may_assign?
      model.assign
    end

    true
  end

  def log_event(options, model:, **)
    Event::AssignedApplication.create(
      user: options['current_user'],
      eventable: model,
      email: model.assigned_to.email
    )
  end
end
