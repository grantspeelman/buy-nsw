require 'rails_helper'

RSpec.describe Buyers::BuyerApplication::Create do

  let(:user) { create(:buyer_user) }

  it 'creates a buyer and buyer application' do
    result = Buyers::BuyerApplication::Create.({ }, 'current_user' => user)

    expect(result).to be_success

    expect(Buyer.count).to eq(1)
    expect(BuyerApplication.count).to eq(1)

    expect(result[:application_model]).to be_persisted
    expect(result[:buyer_model]).to be_persisted

    expect(result[:buyer_model].user).to eq(user)
  end

  it 'does not create an additional buyer when one exists' do
    buyer = create(:buyer, user: user)
    result = Buyers::BuyerApplication::Create.({ }, 'current_user' => user)

    expect(Buyer.count).to eq(1)
    expect(BuyerApplication.count).to eq(1)
  end

  it 'does not create an additional application when one exists' do
    buyer = create(:buyer, user: user)
    application = create(:buyer_application, buyer: buyer)

    result = Buyers::BuyerApplication::Create.({ }, 'current_user' => user)

    expect(Buyer.count).to eq(1)
    expect(BuyerApplication.count).to eq(1)
  end

  it 'sets the started_at timestamp for a new application' do
    time = 1.hour.ago

    Timecop.freeze(time) do
      result = Buyers::BuyerApplication::Create.({ }, 'current_user' => user)
      expect(result[:application_model].started_at.to_i).to eq(time.to_i)
    end
  end

  it 'does not update the started_at timestamp for an existing application' do
    buyer = create(:buyer, user: user)
    application = create(:buyer_application, buyer: buyer, started_at: 1.hour.ago)

    result = Buyers::BuyerApplication::Create.({ }, 'current_user' => user)
    expect(result[:application_model].started_at.to_i).to eq(application.started_at.to_i)
  end

end
