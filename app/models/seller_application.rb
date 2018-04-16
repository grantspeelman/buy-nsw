class SellerApplication < ApplicationRecord
  include AASM

  include Concerns::StateScopes

  belongs_to :seller
  belongs_to :assigned_to, class_name: 'User', optional: true

  aasm column: :state do
    state :created, initial: true
    state :awaiting_assignment
    state :assigned
    state :approved
    state :rejected

    event :submit do
      transitions from: :created, to: :awaiting_assignment, guard: :unassigned?
      transitions from: :created, to: :assigned, guard: :assignee_present?

      before do
        self.submitted_at = Time.now
      end
    end

    event :assign do
      transitions from: :awaiting_assignment, to: :assigned
    end

    event :approve do
      transitions from: :assigned, to: :approved

      after_commit do
        seller.make_active!
        seller.products.each(&:make_active!)
      end
    end

    event :reject do
      transitions from: :assigned, to: :rejected
    end

    event :return_to_applicant do
      transitions from: :assigned, to: :created
    end
  end

  def owner
    seller.owner
  end

  def assignee_present?
    assigned_to.present?
  end

  def unassigned?
    ! assignee_present?
  end

  scope :for_review, -> { submitted.or(assigned) }

  scope :unassigned, -> { where('assigned_to_id IS NULL') }
  scope :assigned_to, ->(user) { where('assigned_to_id = ?', user) }
end
