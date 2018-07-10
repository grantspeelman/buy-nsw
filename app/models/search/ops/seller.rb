module Search::Ops
  class Seller < Search::Base

    def available_filters
      {
        state: state_keys,
      }
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
      scope.yield_self(&method(:state_filter))
    end
  end
end
