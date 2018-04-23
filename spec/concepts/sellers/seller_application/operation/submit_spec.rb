require 'rails_helper'

RSpec.describe Sellers::SellerApplication::Submit do

  let(:application) { create(:created_seller_application) }
  let(:current_user) { create(:user) }

  it 'logs an event' do
    Sellers::SellerApplication::Submit.(
      { },
      'current_user' => current_user,
      application_model: application
    )
    application.reload

    expect(application.events.first.user).to eq(current_user)
    expect(application.events.first.message).to eq("Submitted application")
  end
end
