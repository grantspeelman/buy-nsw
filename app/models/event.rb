class Event < ApplicationRecord
  # The thing that was changed
  belongs_to :eventable, polymorphic: true
  # Who made the change
  belongs_to :user, optional: true
  serialize :message_params, Hash

  def message
    I18n.t("ops.buyer_applications.events.messages.#{message_type}", message_params)
  end

  def self.submit_application!(user, application)
    create(
      user: user,
      eventable: application,
      message_type: 'submitted_application'
    )
  end

  def self.manager_approve!(application)
    create(
      # The manager did something but they are not a user on the system
      user: nil,
      eventable: application,
      message_type: 'manager_approved',
      message_params: {
        name: application.manager_name,
        email: application.manager_email
      }
    )
  end
end
