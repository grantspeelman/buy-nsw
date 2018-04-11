module Concerns::StateScopes

  extend ActiveSupport::Concern
  
  included do
    scope :in_state, ->(state) { where('state = ?', state) }
  end

end
