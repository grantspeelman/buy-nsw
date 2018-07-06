require 'rails_helper'

RSpec.describe Sellers::SellerVersion::Invitation::Accept do

  let(:token) { 'my-confirmation-token' }
  let(:password_params) {
    {
      password: 'foo bar baz',
      password_confirmation: 'foo bar baz',
    }
  }

  let(:application) { create(:created_seller_version) }
  let!(:invited_user) { create(:seller_user, seller: application.seller, confirmed_at: nil, confirmation_token: token) }

  it 'confirms the user' do
    result = described_class.({ application_id: application.id, confirmation_token: token, user: password_params })

    expect(result).to be_success
    expect(invited_user.reload.confirmed_at).to be_present
  end

  context 'failure states' do
    it 'does not confirm the user given an incorrect token' do
      result = described_class.({ application_id: application.id, confirmation_token: 'foo', user: password_params })

      expect(result).to be_failure
      expect(invited_user.reload.confirmed_at).to be_blank
    end

    it 'does not confirm the user given a non-existant application' do
      result = described_class.({ application_id: '12345', confirmation_token: token, user: password_params })

      expect(result).to be_failure
      expect(invited_user.reload.confirmed_at).to be_blank
    end

    it 'does not confirm the user given a different application' do
      other_application = create(:created_seller_version)
      result = described_class.({ application_id: other_application.id, confirmation_token: token, user: password_params })

      expect(result).to be_failure
      expect(invited_user.reload.confirmed_at).to be_blank
    end

    it 'does not confirm the user when the application is in the wrong state' do
      other_application = create(:awaiting_assignment_seller_version)
      other_token = 'another-confirmation-token'

      user = create(:seller_user, seller: other_application.seller, confirmed_at: nil, confirmation_token: other_token)

      result = described_class.({ application_id: other_application.id, confirmation_token: other_token, user: password_params })

      expect(result).to be_failure
      expect(user.reload.confirmed_at).to be_blank
    end

    context 'with errors on the User model' do
      let(:invalid_password_params) {
        {
          password: 'password',
          password_confirmation: 'password',
        }
      }

      it 'sets them on the contract' do
        result = described_class.({ application_id: application.id, confirmation_token: token, user: invalid_password_params })

        expect(result).to be_failure
        expect(result['contract.default'].errors[:password]).to be_present
      end
    end
  end
end
