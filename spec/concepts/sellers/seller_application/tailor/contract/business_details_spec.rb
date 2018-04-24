require 'rails_helper'

RSpec.describe Sellers::SellerApplication::Tailor::Contract::BusinessDetails do
  let(:seller) { create(:inactive_seller) }
  let(:application) { create(:seller_application, seller: seller) }

  subject { Sellers::SellerApplication::Tailor::Contract::BusinessDetails.new(application: application, seller: seller) }

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
    expect(subject.errors[:abn]).to be_present
  end

  it 'is also valid when the ABN has no spaces' do
    subject.validate(atts.merge(abn: '24138089942'))

    expect(subject).to be_valid
  end
end
