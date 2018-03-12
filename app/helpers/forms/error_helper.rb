module Forms::ErrorHelper
  def error_class_for(form, field)
    if form.object.errors && form.object.errors[field].any?
      'is-invalid'
    end
  end
end
