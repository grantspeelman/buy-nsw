class ProductSearch
  attr_reader :term, :section

  def initialize(term:, section:, selected_filters: {})
    @term = term
    @section = section
    @selected_filters = selected_filters
  end

  def results
    @results ||= apply_filters(products)
  end

  def result_count
    results.size
  end

  def available_filters
    {
      audiences: audiences_keys,
    }
  end

  def selected_filters
    @selected_filters.slice(*available_filters.keys)
  end

  def filter_selected?(filter, option)
    selected_filters[filter]&.include?(option.to_s)
  end

private
  def products
    Product.with_section(section).active
  end

  def apply_filters(scope)
    scope.yield_self(&method(:term_filter)).
          yield_self(&method(:audiences_filter))
  end

  def term_filter(relation)
    if term.present?
      relation = relation.basic_search(term)
    else
      relation
    end
  end

  def audiences_filter(relation)
    relation
    audiences_keys.each do |audience|
      if filter_selected?(:audiences, audience)
        relation = relation.with_audience(audience)
      end
    end
    relation
  end

  def audiences_keys
    Product.audiences.values
  end
end
