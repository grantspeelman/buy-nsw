class Buyer < ApplicationRecord
  include AASM
  extend Enumerize

  include Concerns::StateScopes

  belongs_to :user
  has_many :applications, class_name: 'BuyerApplication'
  has_many :product_orders

  enumerize :employment_status, in: ['employee', 'contractor', 'other-eligible']

  aasm column: :state do
    state :inactive, initial: true
    state :active

    event :make_active do
      transitions from: :inactive, to: :active
    end

    event :make_inactive do
      transitions from: :active, to: :inactive
    end
  end

  def application_in_progress?
    applications.created.any?
  end

  def recent_application
    applications.last
  end
end
