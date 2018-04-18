require 'rails_helper'

RSpec.describe Sellers::SellerApplication::Contract::Industry do

  let(:seller) { create(:inactive_seller) }
  let(:application) { create(:seller_application, seller: seller) }

  subject { Sellers::SellerApplication::Contract::Industry.new(application: application, seller: seller) }

  let(:atts) {
    {
      industry: ['ict']
    }
  }

  it 'can save with valid attributes' do
    subject.validate(atts)

    expect(subject).to be_valid
    expect(subject.save).to eq(true)
  end

  it 'is invalid when no industries are provided' do
    subject.validate(atts.merge(industry: nil))

    expect(subject).to_not be_valid
    expect(subject.errors[:industry]).to be_present
  end

  it 'is invalid given an industry that is not in the pre-existing list' do
    subject.validate(atts.merge(industry: ['aviation']))

    expect(subject).to_not be_valid
    expect(subject.errors[:industry]).to be_present
  end

  it 'is valid with blank values provided in the list' do
    subject.validate(atts.merge(
      industry: ['ict', '']
    ))

    expect(subject).to be_valid
    expect(subject.save).to eq(true)
  end
end
