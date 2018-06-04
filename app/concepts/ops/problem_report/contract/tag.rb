module Ops::ProblemReport::Contract
  class Tag < Reform::Form
    property :tags

    def tags=(string)
      super(string.split(' '))
    end

    def tags
      super.join(' ')
    end
  end
end
