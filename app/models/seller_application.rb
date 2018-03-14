class SellerApplication < ApplicationRecord
  include AASM

  belongs_to :owner, class_name: 'User'
  belongs_to :seller

  aasm column: :state do
    state :created, initial: true
    state :submitted
    state :approved
    state :rejected

    event :submit do
      transitions from: :created, to: :submitted
    end
  end

  scope :created, ->{ where(state: :created) }
end
