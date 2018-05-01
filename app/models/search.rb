class Search
  class MissingBaseRelation < StandardError; end

  def initialize(selected_filters: {}, page: nil, per_page: nil)
    @selected_filters = selected_filters
    @page = page
    @per_page = per_page
  end

  def results
    @results ||= apply_filters(base_relation)
  end

  def paginated_results
    @paginated_results ||= apply_pagination(results)
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
  attr_reader :page, :per_page

  def base_relation
    raise(MissingBaseRelation, 'Missing base_relation method. You need to override this in your Search subclass.')
  end

  def apply_filters(scope)
    scope
  end

  def apply_pagination(scope)
    if page
      scope.page(page).per(per_page)
    else
      scope
    end
  end

end
