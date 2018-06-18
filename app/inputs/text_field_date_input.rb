class TextFieldDateInput < SimpleForm::Inputs::DateTimeInput
  def input(wrapper_options = nil)
    out = ActiveSupport::SafeBuffer.new
    date = object.send(attribute_name)

    [:day, :month, :year].each_with_index do |type, index|
      value = date.is_a?(Date) ? date.send(type) : nil

      i = "#{3-index}i"
      key = "#{attribute_name}(#{i})"
      classes = "form-control #{type}"

      field = template.content_tag(:div, class: 'form-group') do
        @builder.label(key, for: key, label: type.to_s.capitalize) +
        @builder.text_field(attribute_name, name: "#{@builder.object_name}[#{key}]", value: value, id: key, class: classes)
      end
      out << field
    end

    out
  end
end
