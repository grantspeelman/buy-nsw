require 'rails_helper'

RSpec.describe Ops::WaitingSeller::Invite do
  include ActiveJob::TestHelper

  let(:waiting_sellers) { create_list(:waiting_seller, 5) }
  let(:waiting_seller) { waiting_sellers.first }

  def perform_operation
    described_class.({ invite: { ids: waiting_sellers.map(&:id) } })
  end

  it 'is successful' do
    expect(perform_operation).to be_success
  end

  it 'sets "invitation_state" of all sellers to "invited"' do
    perform_operation

    waiting_sellers.each do |seller|
      expect(seller.reload.invitation_state).to eq('invited')
    end
  end

  it 'sets the "invitation_token"' do
    allow(SecureRandom).to receive(:hex).and_return('secret token')
    perform_operation

    waiting_sellers.each do |seller|
      expect(seller.reload.invitation_token).to eq('secret token')
    end
  end

  it 'sets the "invited_at" timestamp' do
    time = 1.hour.ago

    Timecop.freeze(time) do
      perform_operation
    end

    waiting_sellers.each do |seller|
      expect(seller.reload.invited_at.to_i).to eq(time.to_i)
    end
  end

  it 'sends an invitation email' do
    allow(WaitingSellerMailer).to receive(:with).
                                    with(waiting_seller: kind_of(WaitingSeller)).
                                    and_call_original

    expect {
      perform_enqueued_jobs { perform_operation }
    }.to change { ActionMailer::Base.deliveries.count }.by(5)
  end

  describe 'failure states' do
    it 'fails when no parameters are present' do
      result = described_class.({})

      expect(result).to be_failure
      expect(result['result.error']).to eq(:no_ids)
    end

    it 'fails when a waiting seller does not exist' do
      expect {
        described_class.({ invite: { ids: ['abc'] }})
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'fails when a waiting seller does not have an "invitation_state" of "created"' do
      waiting_seller = create(:invited_waiting_seller)

      expect {
        described_class.({ invite: { ids: [ waiting_seller.id ] }})
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'fails when a waiting seller is invalid' do
      waiting_seller.update_attribute(:name, '')
      result = perform_operation

      expect(result).to be_failure
      expect(result['result.invalid_model_ids']).to contain_exactly(waiting_seller.id)
      expect(waiting_seller.reload.invitation_state).to eq('created')
    end
  end

end
