class SellerSearch < Search
  attr_reader :term

  def initialize(term:, selected_filters: {})
    @term = term

    super(selected_filters: selected_filters)
  end

  def available_filters
    {
      services: service_keys,
      business_identifiers: [:disability, :indigenous, :not_for_profit, :regional, :start_up, :sme],
    }
  end

private
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

  def start_up_filter(relation)
    if filter_selected?(:business_identifiers, :start_up)
      relation.start_up
    else
      relation
    end
  end

  def sme_filter(relation)
    if filter_selected?(:business_identifiers, :sme)
      relation.sme
    else
      relation
    end
  end

  def disability_filter(relation)
    if filter_selected?(:business_identifiers, :disability)
      relation.disability
    else
      relation
    end
  end

  def regional_filter(relation)
    if filter_selected?(:business_identifiers, :regional)
      relation.regional
    else
      relation
    end
  end

  def not_for_profit_filter(relation)
    if filter_selected?(:business_identifiers, :not_for_profit)
      relation.not_for_profit
    else
      relation
    end
  end

  def indigenous_filter(relation)
    if filter_selected?(:business_identifiers, :indigenous)
      relation.indigenous
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
