module Ops::SellerApplications::FiltersHelper
  def prepare_filter_options(key, options)
    empty_value = [""]

    options = options.map {|option|
      if option.is_a?(Array)
        option
      else
        [ t("ops.seller_applications.search.filters.#{key}.options.#{option}"), option ]
      end
    }

    empty_value + options
  end
end
