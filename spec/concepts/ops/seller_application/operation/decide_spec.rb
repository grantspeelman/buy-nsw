require 'rails_helper'

RSpec.describe Ops::SellerApplication::Decide do

  let(:application) { create(:assigned_seller_application) }

  it 'can approve an application' do
    result = Ops::SellerApplication::Decide.(
               {
                 id: application.id,
                 seller_application: {
                   decision: 'approve',
                   response: 'Response',
                 }
               }
             )

    expect(result).to be_success

    application.reload

    expect(application.state).to eq('approved')
    expect(application.response).to eq('Response')
  end

  it 'sends an email when an application is approved' do
    expect {
      Ops::SellerApplication::Decide.(
                 {
                   id: application.id,
                   seller_application: {
                     decision: 'approve',
                     response: 'Response',
                   }
                 }
               )
    }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end

  it 'can reject an application' do
    result = Ops::SellerApplication::Decide.(
               {
                 id: application.id,
                 seller_application: {
                   decision: 'reject',
                   response: 'Response',
                 }
               }
             )

    expect(result).to be_success

    application.reload

    expect(application.state).to eq('rejected')
    expect(application.response).to eq('Response')
  end

  it 'sends an email when the application is rejected' do
    expect {
      Ops::SellerApplication::Decide.(
                 {
                   id: application.id,
                   seller_application: {
                     decision: 'reject',
                     response: 'Response',
                   }
                 }
               )
    }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end

  it 'can return an application to the seller' do
    result = Ops::SellerApplication::Decide.(
               {
                 id: application.id,
                 seller_application: {
                   decision: 'return_to_applicant',
                   response: 'Response',
                 }
               }
             )

    expect(result).to be_success

    application.reload

    expect(application.state).to eq('created')
    expect(application.response).to eq('Response')
  end

  it 'sends an email when the application is returned to the seller' do
    expect {
      Ops::SellerApplication::Decide.(
                 {
                   id: application.id,
                   seller_application: {
                     decision: 'return_to_applicant',
                     response: 'Response',
                   }
                 }
               )
    }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end

  it 'sets a decided_at timestamp' do
    time = Time.now

    Timecop.freeze(time) do
      result = Ops::SellerApplication::Decide.(
                 {
                   id: application.id,
                   seller_application: {
                     decision: 'approve',
                     response: 'Response',
                   }
                 }
               )
    end
    application.reload

    expect(application.decided_at.to_i).to eq(time.to_i)
  end

  it 'fails when the state transition is not valid' do
    application = create(:created_seller_application)

    result = Ops::SellerApplication::Decide.(
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
