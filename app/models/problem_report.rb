class ProblemReport < ApplicationRecord
  include AASM

  aasm column: :state do
    state :open, initial: true
    state :resolved

    event :resolve do
      transitions from: :open, to: :resolved
    end
  end

  belongs_to :user, optional: true
  belongs_to :resolved_by, class_name: 'User', optional: true

  validate :validate_presence_of_task_or_issue

  scope :in_state, ->(state) { where(state: state) }
  scope :with_tag, ->(tag) { where(":tag = ANY(tags)", tag: tag) }

  def validate_presence_of_task_or_issue
    unless task.present? || issue.present?
      errors.add(:base, 'must be have a task or issue')
    end
  end
end
