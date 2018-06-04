class Ops::ProblemReport::Tag < Trailblazer::Operation
  class Present < Trailblazer::Operation
    step Model( ProblemReport, :find_by )
    step Contract::Build( constant: Ops::ProblemReport::Contract::Tag )
  end

  step Nested(Present)
  step Contract::Validate( key: :problem_report )
  step Contract::Persist()
end
