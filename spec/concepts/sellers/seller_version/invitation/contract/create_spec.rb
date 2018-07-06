require 'rails_helper'

RSpec.describe Sellers::SellerVersion::Invitation::Contract::Create do
  let(:application) { create(:seller_version) }
  let(:user) { create(:seller_user, seller: application.seller) }

  subject { described_class.new(user) }

  it 'is valid with valid attributes' do
    subject.validate({email: 'foo@bar.com'})

    expect(subject).to be_valid
  end

  it 'is invalid with a bad email address' do
    subject.validate({email: 'foobar.com'})

    expect(subject).to_not be_valid
  end
end
