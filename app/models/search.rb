class Search
  def initialize(selected_filters: {})
    @selected_filters = selected_filters
  end

  def results
    @results ||= apply_filters(base_relation)
  end

  def result_count
    results.size
  end

  def available_filters
    { }
  end

  def selected_filters
    @selected_filters.slice(*available_filters.keys)
  end

  def filter_selected?(filter, option = nil)
    value = filter_value(filter)

    if option.present? && value.present?
      value.is_a?(Array) ? value.map(&:to_s).include?(option.to_s) : value.to_s == option.to_s
    else
      filter_value(filter).present?
    end
  end

  def filter_value(filter)
    selected_filters[filter]
  end

private
  def base_relation
    raise('Missing base_relation in Search instance')
  end

  def apply_filters(scope)
    scope
  end

end
