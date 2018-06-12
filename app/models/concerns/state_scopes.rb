module Concerns::StateScopes

  extend ActiveSupport::Concern

  included do
    scope :in_state, ->(state) { where('state = ?', state) }

    scope :order_by_started_at, ->{ order('started_at DESC') }
    scope :order_by_submitted_at, ->{ order('submitted_at DESC') }
    scope :order_by_decided_at, ->{ order('decided_at DESC') }
  end

end
