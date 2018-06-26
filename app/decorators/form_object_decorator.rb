class FormObjectDecorator < BaseDecorator
  # Override the `class` method so that the underlying form object can continue
  # to be used to build labels.
  #
  def class
    __getobj__.class
  end

  def errors
    if __getobj__.respond_to?(:errors)
      FormErrorDecorator.new(super, view_context)
    else
      Hash.new([])
    end
  end
end
