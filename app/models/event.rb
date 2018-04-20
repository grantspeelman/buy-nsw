class Event < ApplicationRecord
  # The thing that was changed
  belongs_to :eventable, polymorphic: true
  # Who made the change
  belongs_to :user
end
