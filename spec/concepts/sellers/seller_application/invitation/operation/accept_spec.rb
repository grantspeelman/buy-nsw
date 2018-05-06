require 'rails_helper'

RSpec.describe Sellers::SellerApplication::Invitation::Accept do

  subject { Sellers::SellerApplication::Invitation::Accept }

  let(:token) { 'my-confirmation-token' }
  let(:password_params) {
    {
      password: 'foo bar baz',
      password_confirmation: 'foo bar baz',
    }
  }

  let(:application) { create(:created_seller_application) }
  let!(:invited_user) { create(:seller_user, seller: application.seller, confirmed_at: nil, confirmation_token: token) }

  it 'confirms the user' do
    result = subject.({ application_id: application.id, confirmation_token: token, user: password_params })

    expect(result).to be_success
    expect(invited_user.reload.confirmed_at).to be_present
  end

  context 'failure states' do
    it 'does not confirm the user given an incorrect token' do
      result = subject.({ application_id: application.id, confirmation_token: 'foo', user: password_params })

      expect(result).to be_failure
      expect(invited_user.reload.confirmed_at).to be_blank
    end

    it 'does not confirm the user given a non-existant application' do
      result = subject.({ application_id: '12345', confirmation_token: token, user: password_params })

      expect(result).to be_failure
      expect(invited_user.reload.confirmed_at).to be_blank
    end

    it 'does not confirm the user given a different application' do
      other_application = create(:created_seller_application)
      result = subject.({ application_id: other_application.id, confirmation_token: token, user: password_params })

      expect(result).to be_failure
      expect(invited_user.reload.confirmed_at).to be_blank
    end

    it 'does not confirm the user when the application is in the wrong state' do
      other_application = create(:awaiting_assignment_seller_application)
      other_token = 'another-confirmation-token'

      user = create(:seller_user, seller: other_application.seller, confirmed_at: nil, confirmation_token: other_token)

      result = subject.({ application_id: other_application.id, confirmation_token: other_token, user: password_params })

      expect(result).to be_failure
      expect(user.reload.confirmed_at).to be_blank
    end
  end

end
