class BaseDecorator < SimpleDelegator
  def initialize(base, view_context)
    super(base)
    @view_context = view_context
  end

private
  attr_reader :view_context
end
