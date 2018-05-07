module Pathways::ProductsHelper

  # NOTE: This approach allows us to still convert new lines into paragraphs
  # and line break tags, but escapes all HTML so that links and other formatting
  # isn't parsed by simple_format
  #
  def format_text_block(text)
    simple_format h(text)
  end

end
