module Forms::LabelHelper
  def service_description_text(key)
    I18n.translate(key, scope: [:sellers, :applications, :steps, :services, :descriptions])
  end

  def form_options_with_labels(i18n_scope, field, values)
    values.map {|value|
      label = I18n.t(value, scope: [i18n_scope, field])
      [ label, value ]
    }
  end
end
