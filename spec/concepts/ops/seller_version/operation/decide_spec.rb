require 'rails_helper'

RSpec.describe Ops::SellerVersion::Decide do
  include ActiveJob::TestHelper

  let(:current_user) { create(:admin_user) }
  let(:application) { create(:ready_for_review_seller_version) }
  let(:approve_params) {
    {
      id: application.id,
      seller_application: {
        decision: 'approve',
        response: 'Response',
      }
    }
  }
  let(:reject_params) {
    {
      id: application.id,
      seller_application: {
        decision: 'reject',
        response: 'Response',
      }
    }
  }
  let(:return_to_seller_params) {
    {
      id: application.id,
      seller_application: {
        decision: 'return_to_applicant',
        response: 'Response',
      }
    }
  }

  it 'can approve an application' do
    result = described_class.(approve_params)

    expect(result).to be_success

    application.reload

    expect(application.state).to eq('approved')
    expect(application.response).to eq('Response')
  end

  it 'logs an event when an application is approved' do
    described_class.(approve_params, 'current_user' => current_user)
    application.reload

    expect(application.events.first.user).to eq(current_user)
    expect(application.events.first.message).to eq("Approved application. Response: Response")
  end

  it 'sends an email when an application is approved' do
    expect {
      perform_enqueued_jobs do
        described_class.(approve_params)
      end
    }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end

  it 'can reject an application' do
    result = described_class.(reject_params)

    expect(result).to be_success

    application.reload

    expect(application.state).to eq('rejected')
    expect(application.response).to eq('Response')
  end

  it 'logs an event when an application is rejected' do
    described_class.(reject_params, 'current_user' => current_user)
    application.reload

    expect(application.events.first.user).to eq(current_user)
    expect(application.events.first.message).to eq("Rejected application. Response: Response")
  end

  it 'sends an email when the application is rejected' do
    expect {
      perform_enqueued_jobs do
        described_class.(reject_params)
      end
    }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end

  it 'can return an application to the seller' do
    result = described_class.(return_to_seller_params)

    expect(result).to be_success

    application.reload

    expect(application.state).to eq('created')
    expect(application.response).to eq('Response')
  end

  it 'logs an event when an application is returned to the seller' do
    described_class.(return_to_seller_params, 'current_user' => current_user)
    application.reload

    expect(application.events.first.user).to eq(current_user)
    expect(application.events.first.message).to eq("Returned application to seller. Response: Response")
  end

  it 'sends an email when the application is returned to the seller' do
    expect {
      perform_enqueued_jobs do
        described_class.(return_to_seller_params)
      end
    }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end

  it 'sets a decided_at timestamp' do
    time = Time.now

    Timecop.freeze(time) do
      result = described_class.(approve_params)
    end
    application.reload

    expect(application.decided_at.to_i).to eq(time.to_i)
  end

  it 'fails when the state transition is not valid' do
    application = create(:created_seller_version)

    result = described_class.(
               {
                 id: application.id,
                 seller_application: {
                   decision: 'approve',
                   response: 'Response',
                 }
               }
             )

    expect(result).to be_failure
  end

end
