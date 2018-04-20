class Event < ApplicationRecord
  # The thing that was changed
  belongs_to :eventable, polymorphic: true
  # Who made the change
  belongs_to :user

  def self.submit_application!(user, application)
    create(
      user: user,
      eventable: application,
      # TODO: Move text into config/locales/en.yml
      description: "Submitted application"
    )
  end
end
