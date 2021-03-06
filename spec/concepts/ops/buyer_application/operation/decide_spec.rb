require 'rails_helper'

RSpec.describe Ops::BuyerApplication::Decide do
  include ActiveJob::TestHelper

  let(:current_user) { create(:admin_user) }
  let(:application) { create(:ready_for_review_buyer_application) }

  it 'can approve an application' do
    result = Ops::BuyerApplication::Decide.(
               {
                 id: application.id,
                 buyer_application: {
                   decision: 'approve',
                   decision_body: 'Response',
                 }
               }
             )

    expect(result).to be_success

    application.reload

    expect(application.state).to eq('approved')
    expect(application.decision_body).to eq('Response')
  end

  it 'logs an event when approving an application' do
    Ops::BuyerApplication::Decide.(
               {
                 id: application.id,
                 buyer_application: {
                   decision: 'approve',
                   decision_body: 'Response',
                 }
               },
               'current_user' => current_user
             )
    application.reload

    expect(application.events.first.user).to eq(current_user)
    expect(application.events.first.message).to eq("Approved application. Response: Response")
  end


  it 'sends an email when an application is approved' do
    expect {
      perform_enqueued_jobs do
        Ops::BuyerApplication::Decide.(
                   {
                     id: application.id,
                     buyer_application: {
                       decision: 'approve',
                       decision_body: 'Response',
                     }
                   }
                 )
      end
    }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end

  it 'can reject an application' do
    result = Ops::BuyerApplication::Decide.(
               {
                 id: application.id,
                 buyer_application: {
                   decision: 'reject',
                   decision_body: 'Response',
                 }
               }
             )

    expect(result).to be_success

    application.reload

    expect(application.state).to eq('rejected')
    expect(application.decision_body).to eq('Response')
  end

  it 'logs an event when rejecting an application' do
    Ops::BuyerApplication::Decide.(
               {
                 id: application.id,
                 buyer_application: {
                   decision: 'reject',
                   decision_body: 'Response',
                 }
               },
               'current_user' => current_user
             )
    application.reload

    expect(application.events.first.user).to eq(current_user)
    expect(application.events.first.message).to eq("Rejected application. Response: Response")
  end

  it 'sends an email when the application is rejected' do
    expect {
      perform_enqueued_jobs do
        Ops::BuyerApplication::Decide.(
                   {
                     id: application.id,
                     buyer_application: {
                       decision: 'reject',
                       decision_body: 'Response',
                     }
                   }
                 )
      end
    }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end

  it 'sets a decided_at timestamp' do
    time = Time.now

    Timecop.freeze(time) do
      result = Ops::BuyerApplication::Decide.(
                 {
                   id: application.id,
                   buyer_application: {
                     decision: 'approve',
                     decision_body: 'Response',
                   }
                 }
               )
    end
    application.reload

    expect(application.decided_at.to_i).to eq(time.to_i)
  end

  it 'fails when the state transition is not valid' do
    application = create(:created_buyer_application)

    result = Ops::BuyerApplication::Decide.(
               {
                 id: application.id,
                 buyer_application: {
                   decision: 'approve',
                   decision_body: 'Response',
                 }
               }
             )

    expect(result).to be_failure
  end

end
