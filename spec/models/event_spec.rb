require 'rails_helper'

RSpec.describe Event, type: :model do
  describe Event::ManagerApproved do
    it '#message' do
      event = Event::ManagerApproved.new(
        name: "Manager",
        email: "manager@example.com"
      )
      expect(event.message).to eq("Manager Manager (manager@example.com) approved the buyer")
    end
  end

  describe Event::Note do
    it '#message' do
      note = Event::Note.new(
        note: "This is a private note to other ops users"
      )
      expect(note.message).to eq("Note added: This is a private note to other ops users")
    end
  end
end
