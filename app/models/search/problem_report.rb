module Search
  class ProblemReport < Base
    include ActiveRecord::Sanitization::ClassMethods

    def available_filters
      {
        state: state_keys,
        url: :term_filter,
        tag: :term_filter,
      }
    end

  private
    def base_relation
      ::ProblemReport.all
    end

    def state_keys
      ::ProblemReport.aasm.states.map(&:name)
    end

    def apply_filters(scope)
      scope.yield_self(&method(:url_filter)).
            yield_self(&method(:tag_filter)).
            yield_self(&method(:state_filter))
    end

    def url_filter(relation)
      if filter_selected?(:url)
        url = filter_value(:url)
        relation = relation.where('url LIKE ?', "%#{sanitize_sql_like(url)}%")
      else
        relation
      end
    end

    def tag_filter(relation)
      if filter_selected?(:tag)
        tag = filter_value(:tag)
        relation = relation.with_tag(tag)
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
end
