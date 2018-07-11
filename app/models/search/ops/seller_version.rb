module Search::Ops
  class SellerVersion < Search::Base

    def available_filters
      {
        assigned_to: assigned_to_keys,
        state: state_keys,
        name: :term_filter,
        email: :term_filter,
        sort: sort_keys,
      }
    end

  private
    include Concerns::Search::ApplicationFilters

    def base_relation
      ::SellerVersion.all
    end

    def state_keys
      ::SellerVersion.aasm.states.map(&:name)
    end

    def assigned_to_keys
      ::User.admin.map {|user|
        [ user.email, user.id ]
      }
    end

    def apply_filters(scope)
      scope.yield_self(&method(:state_filter)).
            yield_self(&method(:assigned_to_filter)).
            yield_self(&method(:sort_filter)).
            yield_self(&method(:name_filter)).
            yield_self(&method(:email_filter))
    end

    def name_filter(relation)
      if filter_selected?(:name)
        term = filter_value(:name)
        relation.basic_search(name: term)
      else
        relation
      end
    end

    def email_filter(relation)
      if filter_selected?(:email)
        term = filter_value(:email)
        relation.joins(:owners).basic_search(users: { email: term })
      else
        relation
      end
    end
  end
end
