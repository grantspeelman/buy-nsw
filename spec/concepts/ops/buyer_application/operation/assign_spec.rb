require 'rails_helper'

RSpec.describe Ops::BuyerApplication::Assign do

  let(:application) { create(:awaiting_assignment_buyer_application) }
  let(:current_user) { create(:admin_user) }
  let(:user) { create(:admin_user) }
  let(:params) {
    {
      id: application.id,
      buyer_application: {
        assigned_to_id: user.id,
      }
    }
   }

  it 'can assign a user to an application' do
    result = Ops::BuyerApplication::Assign.(params)
    application.reload

    expect(result).to be_success
    expect(application.assigned_to).to eq(user)
  end

  it 'transitions the application to the assigned state if necessary' do
    result = Ops::BuyerApplication::Assign.(params)
    application.reload

    expect(result).to be_success
    expect(application.state).to eq('ready_for_review')
  end

  it 'logs an event' do
    Ops::BuyerApplication::Assign.(params, 'current_user' => current_user)
    application.reload

    expect(application.events.first.user).to eq(current_user)
    expect(application.events.first.message).to eq("Assigned application to #{user.email}")
  end

  it 'does not transition the application if another state' do
    created_application = create(:created_buyer_application)

    result = Ops::BuyerApplication::Assign.(params.merge(id: created_application.id))
    created_application.reload

    expect(result).to be_success
    expect(created_application.state).to eq('created')
  end

end
