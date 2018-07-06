require 'rails_helper'

RSpec.describe Sellers::SellerVersion::Invitation::Create do

  let(:application) { create(:created_seller_version) }
  let(:current_user) { create(:seller_user, seller: application.seller) }

  it 'creates a new user' do
    result = described_class.({ application_id: application.id, invitation: { email: 'blah@example.org' } }, 'config.current_user' => current_user)

    new_user = User.find_by_email('blah@example.org')

    expect(result).to be_success

    expect(new_user).to be_present

    expect(new_user.roles).to contain_exactly('seller')
    expect(new_user.seller).to eq(application.seller)

    expect(new_user.confirmation_token).to be_present
    expect(new_user.confirmed_at).to be_blank
  end

  context 'with errors on the User model' do
    it 'sets them on the contract' do
      result = described_class.({ application_id: application.id, invitation: { email: current_user.email } }, 'config.current_user' => current_user)

      expect(result).to be_failure
      expect(result['contract.default'].errors[:email]).to be_present
    end
  end

end
