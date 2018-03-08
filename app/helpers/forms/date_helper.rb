module Forms::DateHelper
  def date_field_from_value(form, field_name, date, form_options={})
    fields = []

    [:year, :month, :day].each_with_index do |type, index|
      value = date.is_a?(Date) ? date.send(type) : nil

      i = "#{index+1}i"
      key = "#{field_name}(#{i})"

      field_classes = []
      field_classes << 'is-invalid' if form.send(:has_error?, field_name)
      field_classes << type

      fields << form.text_field(key, form_options.merge(label: type.to_s.capitalize, value: value, class: field_classes.join(' ')))
    end

    form.form_group(:field_name, layout: :inline, class: 'date-field') do
      form.label(field_name, for: "#{form.object_name}_#{field_name}(3i)", class: 'primary-label') +
      fields.reverse.join.html_safe +
      errors_for_field(form, field_name)
    end
  end

  def errors_for_field(form, field_name)
    if form.object.errors && errors = form.object.errors[field_name]
      content_tag(:div, errors.join(', '), class: 'invalid-feedback')
    end
  end
end
