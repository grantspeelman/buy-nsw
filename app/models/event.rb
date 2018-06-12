module Event
  class Event < ApplicationRecord
    # The thing that was changed
    belongs_to :eventable, polymorphic: true
    # Who made the change
    belongs_to :user, optional: true

    def locale_name
      "events.messages.#{type.demodulize.underscore}"
    end

    # Default implementation
    def message
      I18n.t(locale_name)
    end
  end

  class SubmittedApplication < Event; end

  class StartedApplication < Event; end

  class ApprovedApplication < Event
    def message
      I18n.t(locale_name, note: note)
    end
  end

  class RejectedApplication < Event
    def message
      I18n.t(locale_name, note: note)
    end
  end

  class ReturnedApplication < Event
    def message
      I18n.t(locale_name, note: note)
    end
  end

  class ManagerApproved < Event
    def message
      I18n.t(locale_name, name: name, email: email)
    end
  end

  class AssignedApplication < Event
    def message
      I18n.t(locale_name, email: email)
    end
  end

  class Note < Event
    def message
      I18n.t(locale_name, note: note)
    end
  end
end
