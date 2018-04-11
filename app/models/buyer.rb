class Buyer < ApplicationRecord
  include AASM
  extend Enumerize

  include Concerns::StateScopes

  belongs_to :user
  has_many :applications, class_name: 'BuyerApplication'

  enumerize :employment_status, in: ['employee', 'contractor']

  aasm column: :state do
    state :inactive, initial: true
    state :active

    event :make_active do
      transitions from: :inactive, to: :active
    end
  end
end
