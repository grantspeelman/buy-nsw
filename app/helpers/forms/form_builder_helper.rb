module Forms::FormBuilderHelper
  def buy_nsw_form_for(object, *args, &block)
    options = args.extract_options!
    simple_form_for(object, *(args << options.merge(builder: BuyNswFormBuilder)), &block)
  end
end
