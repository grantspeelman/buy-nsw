class ProductSearch < Search
  attr_reader :term, :section

  def initialize(term:, section:, selected_filters: {}, page: nil, per_page: nil)
    @term = term
    @section = section

    super(selected_filters: selected_filters, page: page, per_page: per_page)
  end

  def available_filters
    {
      audiences: audiences_keys,
      business_identifiers: [:disability, :indigenous, :not_for_profit, :regional, :start_up, :sme],
    }
  end

private
  include Concerns::Search::SellerTagFilters

  def base_relation
    Product.with_section(section).active
  end

  def apply_filters(scope)
    scope.yield_self(&method(:term_filter)).
          yield_self(&method(:audiences_filter)).
          yield_self(&method(:start_up_filter)).
          yield_self(&method(:sme_filter)).
          yield_self(&method(:disability_filter)).
          yield_self(&method(:regional_filter)).
          yield_self(&method(:indigenous_filter)).
          yield_self(&method(:not_for_profit_filter))
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
