require 'rails_helper'

RSpec.describe Sellers::SellerApplication::Create do

  subject { Sellers::SellerApplication::Create }
  let(:user) { create(:seller_user) }

  it 'creates a seller and seller application' do
    result = subject.({ }, 'current_user' => user)

    expect(result).to be_success

    expect(Seller.count).to eq(1)
    expect(SellerApplication.count).to eq(1)

    expect(result[:application_model]).to be_persisted
    expect(result[:seller_model]).to be_persisted

    expect(result[:seller_model].owners).to contain_exactly(user)
    expect(user.seller).to eq(result[:seller_model])
  end

  it 'does not create an additional seller when one exists' do
    seller = create(:seller, owner: user)
    result = subject.({ }, 'current_user' => user)

    expect(Seller.count).to eq(1)
    expect(SellerApplication.count).to eq(1)
  end

  it 'does not create an additional application when one exists' do
    seller = create(:seller, owner: user)
    application = create(:seller_application, seller: seller)

    result = subject.({ }, 'current_user' => user)

    expect(Seller.count).to eq(1)
    expect(SellerApplication.count).to eq(1)
  end

  it 'sets the started_at timestamp for a new application' do
    time = 1.hour.ago

    Timecop.freeze(time) do
      result = subject.({ }, 'current_user' => user)
      expect(result[:application_model].started_at.to_i).to eq(time.to_i)
    end
  end

  it 'logs an event when the application is started' do
    result = subject.({ }, 'current_user' => user)
    expect(result[:application_model].events.last.message).to eq("Started application")
    expect(result[:application_model].events.last.user).to eq(user)
  end

  it 'does not update the started_at timestamp for an existing application' do
    seller = create(:seller, owner: user)
    application = create(:seller_application, seller: seller, started_at: 1.hour.ago)

    result = subject.({ }, 'current_user' => user)
    expect(result[:application_model].started_at.to_i).to eq(application.started_at.to_i)
  end

  it 'fails when an application has already been submitted' do
    seller = create(:seller, owner: user)
    application = create(:awaiting_assignment_seller_application, seller: seller)

    result = subject.({ }, 'current_user' => user)

    expect(result).to be_failure
  end

end
