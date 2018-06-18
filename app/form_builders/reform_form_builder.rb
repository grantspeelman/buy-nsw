class ReformFormBuilder < SimpleForm::FormBuilder
  def input(attribute_name, options = {}, &block)
    super(attribute_name, custom_input_options(attribute_name, options), &block)
  end

private
  def custom_input_options(attribute_name, options)
    hint_text = translate_hint(attribute_name)
    label_text = translate_label(attribute_name)

    hint_id = "hint_#{attribute_name}" if hint_text.present?
    error_id = "error_#{attribute_name}" if object.errors[attribute_name].any?

    input_html = {
      aria: {
        describedby: [ hint_id, error_id ].compact.join(' '),
      },
    }

    options.merge({
      label: options.fetch(:label, label_text),
      hint: hint_text,
      input_html: options.fetch(:input_html, {}).merge(input_html),
      hint_id: hint_id,
      error_id: error_id,
    })
  end

  def translate_hint(attribute_name)
    scope = [i18n_scope, attribute_name]

    if I18n.exists?([scope, :hint_html].join('.'))
      I18n.t(:hint_html, scope: [i18n_scope, attribute_name]).html_safe
    elsif I18n.exists?([scope, :hint].join('.'))
      I18n.t(:hint, scope: [i18n_scope, attribute_name])
    end
  end

  def translate_label(attribute_name)
    I18n.t(:label, scope: [i18n_scope, attribute_name])
  end

  def i18n_scope
    base = object.respond_to?(:i18n_base) ? object.i18n_base : ''
    key = object.class.name.demodulize.underscore

    [base, key]
  end
end
