class ProblemReport < ApplicationRecord
  belongs_to :user, optional: true

  validate :validate_presence_of_task_or_issue

  def validate_presence_of_task_or_issue
    unless task.present? || issue.present?
      errors.add(:base, 'must be have a task or issue')
    end
  end
end
