module Forms::FormBuilderHelper
  def reform_form_for(object, *args, &block)
    options = args.extract_options!
    simple_form_for(object, *(args << options.merge(builder: ReformFormBuilder)), &block)
  end
end
