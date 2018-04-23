require 'rails_helper'

RSpec.describe Sellers::SellerApplication::Tailor::Contract::Services do
  let(:seller) { create(:inactive_seller) }
  let(:application) { create(:seller_application, seller: seller) }

  subject { Sellers::SellerApplication::Tailor::Contract::Services.new(application: application, seller: seller) }

  let(:atts) {
    {
      services: [
        'cloud-services',
        'managed-services',
        'software-development',
      ]
    }
  }

  it 'can save with valid attributes' do
    subject.validate(atts)

    expect(subject).to be_valid
    expect(subject.save).to eq(true)
  end

  it 'is invalid when no services are provided' do
    subject.validate(atts.merge(services: nil))

    expect(subject).to_not be_valid
    expect(subject.errors[:services]).to be_present
  end

  it 'is invalid given a service that is not in the pre-existing list' do
    subject.validate(atts.merge(services: ['baking']))

    expect(subject).to_not be_valid
    expect(subject.errors[:services]).to be_present
  end

  it 'is valid with blank values provided in the list' do
    subject.validate(atts.merge(
      services: ['cloud-services', '']
    ))

    expect(subject).to be_valid
    expect(subject.save).to eq(true)
  end
end
