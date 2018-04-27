require 'rails_helper'

RSpec.describe Sellers::SellerApplication::Invitation::Create do

  subject { Sellers::SellerApplication::Invitation::Create }

  let(:application) { create(:created_seller_application) }
  let(:current_user) { create(:seller_user, seller: application.seller) }

  it 'creates a new user' do
    result = subject.({ application_id: application.id, invitation: { email: 'blah@example.org' } }, 'current_user' => current_user)

    new_user = User.find_by_email('blah@example.org')

    expect(result).to be_success

    expect(new_user).to be_present

    expect(new_user.roles).to contain_exactly('seller')
    expect(new_user.seller).to eq(application.seller)
    
    expect(new_user.confirmation_token).to be_present
    expect(new_user.confirmed_at).to be_blank
  end

end
