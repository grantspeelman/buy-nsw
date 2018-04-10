module Ops::FiltersHelper
  def prepare_filter_options(resource_name, key, options)
    empty_value = [""]

    options = options.map {|option|
      if option.is_a?(Array)
        option
      else
        [ t("ops.#{resource_name}.search.filters.#{key}.options.#{option}"), option ]
      end
    }

    empty_value + options
  end
end
