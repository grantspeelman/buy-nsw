module Search
  class SellerApplication < Base

    def available_filters
      {
        assigned_to: assigned_to_keys,
        state: state_keys,
      }
    end

  private
    include Concerns::Search::ApplicationFilters

    def base_relation
      ::SellerApplication.all
    end

    def state_keys
      ::SellerApplication.aasm.states.map(&:name)
    end

    def assigned_to_keys
      ::User.admin.map {|user|
        [ user.email, user.id ]
      }
    end

    def apply_filters(scope)
      scope.yield_self(&method(:state_filter)).
            yield_self(&method(:assigned_to_filter))
    end
  end
end
