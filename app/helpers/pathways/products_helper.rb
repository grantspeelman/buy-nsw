module Pathways::ProductsHelper

  # NOTE: This approach allows us to still convert new lines into paragraphs
  # and line break tags, but escapes all HTML so that links and other formatting
  # isn't parsed by simple_format
  #
  def format_text_block(text)
    simple_format h(text)
  end

  def product_field(key, value)
    content_tag(:dt, key) +
      content_tag(:dd, product_value(value))
  end

  def product_value(value)
    case
    when value.is_a?(Array)
      content_tag(:ul) {
        value.map {|item| content_tag(:li, h(item)) }.join.html_safe
      }
    when value.is_a?(Date)
      value.strftime('%d/%m/%Y')
    when value.is_a?(TrueClass)
      'Yes'
    when value.is_a?(FalseClass)
      'No'
    else
      format_text_block(value)
    end
  end

end
