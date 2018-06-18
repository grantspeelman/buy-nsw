class ReformFormBuilder < SimpleForm::FormBuilder
  def input(attribute_name, options = {}, &block)
    super(attribute_name, custom_input_options(attribute_name, options), &block)
  end

  def translate_label(attribute_name)
    I18n.t(:label, scope: [i18n_scope, attribute_name])
  end

  def field_id(attribute_name)
    key = options[:as] || object.model_name
    "#{key}_#{attribute_name}"
  end

  def errors_with_messages
    errors = HashWithIndifferentAccess.new(object.errors.messages)
    errors.keys.map {|field, _|
      error_message_for_field(field)
    }.compact.map {|field|
      [field, field_id(field)]
    }
  end

  def object
    FormObjectDecorator.new(super, self)
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

    if html = translate_if_exists(:hint_html, scope)
      html.html_safe
    else
      translate_if_exists(:hint, scope)
    end
  end

  def i18n_scope
    base = object.respond_to?(:i18n_base) ? object.i18n_base : ''
    key = object.class.name.demodulize.underscore

    [base, key]
  end

  def error_message_for_field(field_name)
    translate_if_exists(:error_label, [i18n_scope, field_name]) ||
      translate_if_exists(:label, [i18n_scope, field_name])
  end

  def translate_if_exists(key, scope)
    if I18n.exists?([scope, key].flatten.join('.'))
      I18n.t(key, scope: scope)
    end
  end
end
