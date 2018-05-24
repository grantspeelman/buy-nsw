class WaitingSeller < ApplicationRecord
  include AASM

  before_save :normalise_abn
  
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

  def editable?
    invitation_state == 'created'
  end

  def invitable?
    may_mark_as_invited?
  end

  scope :in_invitation_state, ->(state) { where(invitation_state: state) }

private
  def normalise_abn
    self.abn = ABN.new(abn).to_s if ABN.valid?(abn)
  end
end
