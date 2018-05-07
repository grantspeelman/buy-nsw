module Ops::SellerApplicationsHelper
  include Sellers::ProfilesHelper

  include Ops::AssigneesHelper
  include Ops::DetailHelper
  include Ops::FiltersHelper

  include Ops::SellerApplications::DetailHelper

  def formatted_product_name(product)
    name = h(product.name || 'Unamed product')
    id = content_tag(:span, "##{h(product.id)}", class: 'product-id')

    ( "#{name} #{id}" ).html_safe
  end
end
