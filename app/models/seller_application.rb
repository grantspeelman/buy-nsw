class SellerApplication < ApplicationRecord
  include AASM

  belongs_to :owner, class_name: 'User'
  belongs_to :assigned_to, class_name: 'User', optional: true

  belongs_to :seller

  aasm column: :state do
    state :created, initial: true
    state :awaiting_assignment
    state :assigned
    state :approved
    state :rejected

    event :submit do
      transitions from: :created, to: :awaiting_assignment
      transitions from: :created, to: :assigned, guard: :assignee_present?

      before do
        self.submitted_at = Time.now
      end
    end

    event :assign, guard: :assignee_present? do
      transitions from: :awaiting_assignment, to: :assigned
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
      transitions from: :assigned, to: :rejected

      before do
        self.decided_at = Time.now
      end
    end
  end

  def assignee_present?
    assigned_to.present?
  end

  scope :for_review, -> { submitted.or(assigned) }
  scope :in_state, ->(state) { where('state = ?', state) }

  scope :unassigned, -> { where('assigned_to_id IS NULL') }
  scope :assigned_to, ->(user) { where('assigned_to_id = ?', user) }
end
