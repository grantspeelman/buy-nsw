module Search::Ops
  class Seller < Search::Seller

    def available_filters
      super.merge(
        state: state_keys,
      )
    end

  private
    include Concerns::Search::ApplicationFilters

    def base_relation
      ::Seller.all
    end

    def state_keys
      ::Seller.aasm.states.map(&:name)
    end

    def apply_filters(scope)
      super(scope).yield_self(&method(:state_filter))
    end
  end
end
