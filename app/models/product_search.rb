class ProductSearch < Search
  attr_reader :term, :section

  def initialize(term:, section:, selected_filters: {})
    @term = term
    @section = section

    super(selected_filters: selected_filters)
  end

  def available_filters
    {
      audiences: audiences_keys,
    }
  end

private
  def base_relation
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
