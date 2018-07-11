require 'rails_helper'

RSpec.describe Sellers::SellerVersion::Contract::BusinessDetails do
  let(:seller) { create(:inactive_seller) }
  let(:version) { create(:seller_version, seller: seller) }

  subject { described_class.new(seller_version: version, seller: seller) }

  let(:atts) {
    {
      name: 'OpenAustralia Foundation',
      abn: '24 138 089 942',
    }
  }

  it 'can save with valid attributes' do
    expect(subject.validate(atts)).to eq(true)
    expect(subject.save).to eq(true)
  end

  it 'is invalid when the name is blank' do
    subject.validate(atts.merge(name: ''))

    expect(subject).to_not be_valid
    expect(subject.errors[:name]).to be_present
  end

  it 'is invalid when the ABN is blank' do
    subject.validate(atts.merge(abn: ''))

    expect(subject).to_not be_valid
    expect(subject.errors[:abn]).to be_present
  end

  it 'is invalid when the ABN is invalid' do
    subject.validate(atts.merge(abn: '10 123 456 789'))

    expect(subject).to_not be_valid
    expect(subject.errors[:abn].count).to eq(1)
  end

  it 'is also valid when the ABN has no spaces' do
    subject.validate(atts.merge(abn: '24138089942'))

    expect(subject).to be_valid
  end

  it 'is invalid if the ABN has already been used' do
    create(:created_seller_version, abn: atts[:abn])

    subject.validate(atts)

    expect(subject).to_not be_valid
    expect(subject.errors[:abn]).to be_present
  end

  it 'is valid when the ABN is in use for another version of the same seller' do
    create(:approved_seller_version, seller: seller, abn: atts[:abn])
    subject.validate(atts)

    expect(subject).to be_valid
  end
end
