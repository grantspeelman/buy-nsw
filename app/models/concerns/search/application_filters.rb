module Concerns::Search::ApplicationFilters
  def state_filter(relation)
    state_keys.each do |state|
      if filter_selected?(:state, state)
        relation = relation.in_state(state)
      end
    end
    relation
  end

  def assigned_to_filter(relation)
    if filter_selected?(:assigned_to)
      relation.assigned_to( filter_value(:assigned_to) )
    else
      relation
    end
  end
end
