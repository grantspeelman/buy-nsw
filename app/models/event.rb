class Event < ApplicationRecord
  # The thing that was changed
  belongs_to :eventable, polymorphic: true
  # Who made the change
  belongs_to :user, optional: true

  def self.submit_application!(user, application)
    create(
      user: user,
      eventable: application,
      # TODO: Move text into config/locales/en.yml
      description: "Submitted application"
    )
  end

  def self.manager_approve!(application)
    create(
      # The manager did something but they are not a user on the system
      user: nil,
      eventable: application,
      description: "Manager #{application.manager_name} (#{application.manager_email}) approved the buyer"
    )
  end
end
