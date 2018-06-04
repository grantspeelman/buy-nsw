module Search
  class WaitingSeller < Base
    attr_reader :term

    def available_filters
      {
        term: :term_filter,
        invitation_state: invitation_state_keys,
      }
    end

  private
    def base_relation
      ::WaitingSeller.all
    end

    def invitation_state_keys
      ::WaitingSeller.aasm.states.map(&:name)
    end

    def apply_filters(scope)
      scope.yield_self(&method(:term_filter)).
            yield_self(&method(:invitation_state_filter))
    end

    def term_filter(relation)
      if filter_selected?(:term)
        term = filter_value(:term)

        relation = relation.basic_search({
          name: term,
          contact_name: term,
        }, false)
      else
        relation
      end
    end

    def invitation_state_filter(relation)
      if filter_selected?(:invitation_state)
        relation.in_invitation_state( filter_value(:invitation_state) )
      else
        relation
      end
    end
  end
end
