class SellerSearch < Search
  attr_reader :term

  def initialize(term:, selected_filters: {}, page: nil, per_page: nil)
    @term = term

    super(selected_filters: selected_filters, page: page, per_page: per_page)
  end

  def available_filters
    {
      services: service_keys,
      business_identifiers: [:disability, :indigenous, :not_for_profit, :regional, :start_up, :sme],
    }
  end

private
  include Concerns::Search::SellerTagFilters

  def base_relation
    Seller.active
  end

  def apply_filters(scope)
    scope.yield_self(&method(:term_filter)).
          yield_self(&method(:start_up_filter)).
          yield_self(&method(:sme_filter)).
          yield_self(&method(:disability_filter)).
          yield_self(&method(:regional_filter)).
          yield_self(&method(:indigenous_filter)).
          yield_self(&method(:not_for_profit_filter)).
          yield_self(&method(:services_filter))
  end

  def term_filter(relation)
    if term.present?
      relation = relation.basic_search(term)
    else
      relation
    end
  end

  def services_filter(relation)
    relation
    service_keys.each do |service|
      if filter_selected?(:services, service)
        relation = relation.with_service(service)
      end
    end
    relation
  end

  def service_keys
    Seller.services.values
  end
end
