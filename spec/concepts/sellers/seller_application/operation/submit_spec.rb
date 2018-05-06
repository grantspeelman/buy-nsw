require 'rails_helper'

RSpec.describe Sellers::SellerApplication::Submit do

  subject { Sellers::SellerApplication::Submit }

  let(:application) { create(:created_seller_application) }
  let(:current_user) { create(:user, seller: application.seller) }

  it 'is successful if the application is in a valid state' do
    result = subject.(
      { id: application.id },
      'current_user' => current_user,
    )

    expect(result).to be_success
    expect(application.reload.state).to eq('awaiting_assignment')
  end

  it 'fails if the application state cannot be transitioned' do
    approved_application = create(:approved_seller_application)
    current_user = create(:user, seller: approved_application.seller)

    result = subject.(
      { id: approved_application.id },
      'current_user' => current_user,
    )

    expect(result).to be_failure
  end

  it 'sets the submitted_at timestamp' do
    time = 1.hour.ago

    Timecop.freeze(time) do
      subject.(
        { id: application.id },
        'current_user' => current_user,
      )
    end
    application.reload

    expect(application.submitted_at.to_i).to eq(time.to_i)
  end

  it 'logs an event' do
    subject.(
      { id: application.id },
      'current_user' => current_user,
    )
    application.reload

    expect(application.events.first.user).to eq(current_user)
    expect(application.events.first.message).to eq("Submitted application")
  end
end
