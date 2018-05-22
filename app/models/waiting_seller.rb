class WaitingSeller < ApplicationRecord
  include AASM

  belongs_to :seller, optional: true

  aasm column: :invitation_state do
    state :created, initial: true
    state :invited
    state :joined

    event :mark_as_invited do
      transitions from: :created, to: :invited
    end

    event :mark_as_joined do
      transitions from: :invited, to: :joined
    end
  end

  scope :in_invitation_state, ->(state) { where(invitation_state: state) }
end
