module Forms::ErrorHelper
  def error_class_for(form, field)
    if form.object.errors && form.object.errors[field].any?
      'is-invalid'
    end
  end

  def user_error_messages_for_model(model)
    model.errors.full_messages.map do |message|
      content_tag :div, class: 'message-alert', role: 'alert' do
        h(message)
      end
    end.join.html_safe
  end
end
