class Ops::ProblemReport::Resolve < Trailblazer::Operation
  step Model( ProblemReport, :find_by )

  step :validate_state!
  step :validate_user!
  step :set_timestamp_and_user!
  step :update_state!
  step :persist!

  def validate_state!(options, model:, **)
    model.may_resolve?
  end

  def validate_user!(options, **)
    options['config.current_user'].present?
  end

  def set_timestamp_and_user!(options, model:, **)
    model.resolved_at = Time.now
    model.resolved_by = options['config.current_user']
  end

  def update_state!(options, model:, **)
    model.resolve
  end

  def persist!(options, model:, **)
    model.save
  end
end
