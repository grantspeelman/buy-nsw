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
    when value.is_a?(Document)
      format_product_upload(value)
    when value.is_a?(TrueClass)
      'Yes'
    when value.is_a?(FalseClass)
      'No'
    else
      format_text_block(value)
    end
  end

  def format_product_upload(upload)
    if upload.document.blank?
      return 'Not provided'
    end

    out = [
      h(upload.original_filename)
    ]

    case upload.scan_status
    when 'clean'
      out << content_tag(:span, class: 'actions') do
        label = h("View document (#{upload.extension}, #{number_to_human_size(upload.size)})")
        link_to(label, upload.document.url, target: '_blank', title: 'Download this document')
      end
    when 'unscanned'
      out << '– awaiting virus scan'
    when 'infected'
      out << '– infected file'
    end

    out.join(' ').html_safe
  end

end
