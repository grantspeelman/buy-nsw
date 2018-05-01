class BuyerSearch < Search

  def available_filters
    {
      term: :term_filter,
      state: state_keys,
    }
  end

private
  def base_relation
    Buyer.all
  end

  def state_keys
    Buyer.aasm.states.map(&:name)
  end

  def apply_filters(scope)
    scope.yield_self(&method(:term_filter)).
          yield_self(&method(:state_filter))
  end

  def term_filter(relation)
    if filter_selected?(:term)
      term = filter_value(:term)

      relation = relation.joins(:user).fuzzy_search({
        name: term,
        organisation: term,
      }, false)
    else
      relation
    end
  end

  def state_filter(relation)
    if filter_selected?(:state)
      relation.in_state( filter_value(:state) )
    else
      relation
    end
  end
end
