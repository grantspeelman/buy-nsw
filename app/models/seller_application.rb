class SellerApplication < ApplicationRecord
  include AASM

  belongs_to :owner, class_name: 'User'
  belongs_to :assigned_to, class_name: 'User', optional: true

  belongs_to :seller

  aasm column: :state do
    state :created, initial: true
    state :submitted
    state :assigned
    state :approved
    state :rejected

    event :submit do
      transitions from: :created, to: :submitted

      before do
        self.submitted_at = Time.now
      end
    end

    event :assign do
      transitions from: :submitted, to: :assigned
    end

    event :approve do
      transitions from: :assigned, to: :approved

      after_commit do
        self.decided_at = Time.now
        seller.make_active!
        seller.products.each(&:make_active!)
      end
    end

    event :reject do
      transitions from: :submitted, to: :rejected

      before do
        self.decided_at = Time.now
      end
    end
  end

  scope :unassigned, -> { where('assigned_to IS NULL') }
  scope :assigned_to, ->(user) { where('assigned_to = ?', user) }
end
