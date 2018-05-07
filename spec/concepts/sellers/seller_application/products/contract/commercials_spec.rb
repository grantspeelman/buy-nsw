require 'rails_helper'

RSpec.describe Sellers::SellerApplication::Products::Contract::Commercials do
  let(:product) { create(:inactive_product) }

  subject { Sellers::SellerApplication::Products::Contract::Commercials.new(
    product: product
  )}

  let(:atts) {
    {
      free_version: false,
      free_trial: false,
      pricing_min: 10,
      pricing_max: 20,
      pricing_unit: "per user per month",
      education_pricing: false,
      free_trial_url: 'https://foo.com/blah'
    }
  }

  it 'is valid with valid attributes' do
    subject.validate(atts)

    expect(subject).to be_valid
  end

  it 'is not valid with an invalid free trial url' do
    subject.validate(atts.merge(free_trial_url: 'foo'))

    expect(subject).to_not be_valid
  end

  it 'is not valid with a free trial url without a host' do
    subject.validate(atts.merge(free_trial_url: '/blah'))

    expect(subject).to_not be_valid
  end
end
