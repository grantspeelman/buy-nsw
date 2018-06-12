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

  def sort_filter(relation)
    case filter_value(:sort)
    when 'started_at' then relation.order_by_started_at
    when 'submitted_at' then relation.order_by_submitted_at
    when 'decided_at' then relation.order_by_decided_at
    else
      relation
    end
  end

  def sort_keys
    [ 'started_at', 'submitted_at', 'decided_at' ]
  end
end
