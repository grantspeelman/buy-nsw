class Event < ApplicationRecord
  # The thing that was changed
  belongs_to :eventable, polymorphic: true
  # Who made the change
  belongs_to :user, optional: true

  def self.submit_application!(user, application)
    create(
      user: user,
      eventable: application,
      description: I18n.t('ops.buyer_applications.events.messages.submitted_application')
    )
  end

  def self.manager_approve!(application)
    create(
      # The manager did something but they are not a user on the system
      user: nil,
      eventable: application,
      description: I18n.t('ops.buyer_applications.events.messages.manager_approved',
        name: application.manager_name, email: application.manager_email)
    )
  end
end
