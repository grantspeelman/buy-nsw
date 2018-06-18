class FormObjectDecorator < BaseDecorator
  # Override the `class` method so that the underlying form object can continue
  # to be used to build labels.
  #
  def class
    __getobj__.class
  end

  def errors
    FormErrorDecorator.new(super, view_context)
  end
end
