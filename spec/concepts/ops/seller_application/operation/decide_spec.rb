require 'rails_helper'

RSpec.describe Ops::SellerApplication::Decide do

  let(:application) { create(:assigned_seller_application) }

  it 'can approve an application' do
    result = Ops::SellerApplication::Decide.(
               params: {
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

  it 'can reject an application' do
    result = Ops::SellerApplication::Decide.(
               params: {
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

  it 'can return an application to the seller' do
    result = Ops::SellerApplication::Decide.(
               params: {
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

  it 'sets a decided_at timestamp' do
    time = Time.now

    Timecop.freeze(time) do
      result = Ops::SellerApplication::Decide.(
                 params: {
                   id: application.id,
                   seller_application: {
                     decision: 'approve',
                     response: 'Response',
                   }
                 }
               )
    end
    application.reload

    expect(application.decided_at).to eq(time)
  end

  it 'fails when the state transition is not valid' do
    application = create(:created_seller_application)

    result = Ops::SellerApplication::Decide.(
               params: {
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
