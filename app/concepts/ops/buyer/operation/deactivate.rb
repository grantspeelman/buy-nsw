class Ops::Buyer::Deactivate < Trailblazer::Operation
  step Model( Buyer, :find_by )

  step :validate_buyer_state!
  step :change_buyer_state!

  def validate_buyer_state!(options, model:, **)
    model.may_make_inactive?
  end

  def change_buyer_state!(options, model:, **)
    model.make_inactive!
  end
end
