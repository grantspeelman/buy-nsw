require 'rails_helper'

RSpec.describe Sellers::SellerApplication::Contract::BusinessDetails do
  let(:seller) { create(:inactive_seller) }
  let(:application) { create(:seller_version, seller: seller) }

  subject { Sellers::SellerApplication::Contract::BusinessDetails.new(application: application, seller: seller) }

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
    create(:inactive_seller, abn: '24 138 089 942')

    subject.validate(atts)

    expect(subject).to_not be_valid
    expect(subject.errors[:abn]).to be_present
  end
end
