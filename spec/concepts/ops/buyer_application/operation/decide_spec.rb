require 'rails_helper'

RSpec.describe Ops::BuyerApplication::Decide do

  let(:application) { create(:assigned_buyer_application) }

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

  it 'sends an email when an application is approved' do
    expect {
      Ops::BuyerApplication::Decide.(
                 {
                   id: application.id,
                   buyer_application: {
                     decision: 'approve',
                     decision_body: 'Response',
                   }
                 }
               )
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

  it 'sends an email when the application is rejected' do
    expect {
      Ops::BuyerApplication::Decide.(
                 {
                   id: application.id,
                   buyer_application: {
                     decision: 'reject',
                     decision_body: 'Response',
                   }
                 }
               )
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
