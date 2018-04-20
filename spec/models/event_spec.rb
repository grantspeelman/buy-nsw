require 'rails_helper'

RSpec.describe Event, type: :model do
  it '#message' do
    event = Event.new(
      message_type: 'manager_approved',
      message_params: {
        name: "Manager",
        email: "manager@example.com"
      }
    )
    expect(event.message).to eq("Manager Manager (manager@example.com) approved the buyer")
  end
end
