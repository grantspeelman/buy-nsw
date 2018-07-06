module Ops::SellerVersionsHelper
  include Sellers::ProfilesHelper

  include Ops::AssigneesHelper
  include Ops::DetailHelper

  include Ops::SellerVersions::DetailHelper

  def formatted_product_name(product)
    name = h(product.name || 'Unamed product')
    id = content_tag(:span, "##{h(product.id)}", class: 'product-id')

    ( "#{name} #{id}" ).html_safe
  end
end
