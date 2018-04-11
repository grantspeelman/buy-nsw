require 'rails_helper'

RSpec.describe Buyers::BuyerApplication::ManagerApprove do

  let(:application) { create(:awaiting_manager_approval_buyer_application) }
  let(:valid_params) {
    {
      id: application.id,
      token: application.manager_approval_token,
    }
  }

  it 'approves an application given the correct token' do
    op = Buyers::BuyerApplication::ManagerApprove.(valid_params)

    expect(op).to be_success
    expect(op['result.approved']).to be_truthy
  end

  it 'advances the application state' do
    expect {
      Buyers::BuyerApplication::ManagerApprove.(valid_params)
    }.to change {
      application.reload.state
    }
  end

  it 'sets the `manager_approved_at` timestamp' do
    time = Time.now

    Timecop.freeze(time) do
      Buyers::BuyerApplication::ManagerApprove.(valid_params)
    end

    expect(application.reload.manager_approved_at.to_i).to eq(time.to_i)
  end

  it 'resets the `manager_approval_token` to nil' do
    Buyers::BuyerApplication::ManagerApprove.(valid_params)

    expect(application.reload.manager_approval_token).to be_nil
  end

  describe 'failure states' do
    it 'fails when the application does not exist' do
      expect(
        Buyers::BuyerApplication::ManagerApprove.(id: 'foo', token: 'token')
      ).to be_failure
    end

    it 'fails when the token is not correct' do
      expect(
        Buyers::BuyerApplication::ManagerApprove.(id: application.id, token: 'not a valid token')
      ).to be_failure
    end

    it 'fails when the application is not in the `awaiting_manager_approval` state' do
      other_application = create(:created_buyer_application)

      expect(
        Buyers::BuyerApplication::ManagerApprove.(id: other_application.id, token: 'token')
      ).to be_failure
    end
  end

end
