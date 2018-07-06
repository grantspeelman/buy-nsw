require 'rails_helper'

RSpec.describe Sellers::SellerVersion::Invitation::Contract::Accept do
  let(:application) { create(:seller_version) }
  let(:user) { create(:seller_user, seller: application.seller) }

  subject { described_class.new(user) }

  let(:atts) {
    {
      password: 'foo bar baz',
      password_confirmation: 'foo bar baz',
    }
  }

  it 'can save with valid attributes' do
    subject.validate(atts)

    expect(subject).to be_valid
    expect(subject.save).to eq(true)
  end

  it 'is invalid when the password is blank' do
    subject.validate(atts.merge(password: nil))

    expect(subject).to_not be_valid
    expect(subject.errors[:password]).to be_present
  end

  it 'is invalid when the password_confirmation is blank' do
    subject.validate(atts.merge(password_confirmation: nil))

    expect(subject).to_not be_valid
    expect(subject.errors[:password_confirmation]).to be_present
  end

  it 'is invalid when passwords do not match' do
    subject.validate(atts.merge(password_confirmation: 'something else'))

    expect(subject).to_not be_valid
    expect(subject.errors[:password_confirmation]).to be_present
  end
end
