require 'rails_helper'

RSpec.describe Sellers::SellerVersion::Products::Contract::Commercials do
  let(:product) { create(:inactive_product) }

  subject { described_class.new(product: product) }

  let(:atts) {
    {
      free_version: false,
      free_trial: false,
      pricing_currency: 'aud',
      pricing_min: 10,
      pricing_max: 20,
      pricing_unit: "per user per month",
      pricing_variables: "no variables",
      education_pricing: false,
      not_for_profit_pricing: false,
      free_trial_url: 'https://foo.com/blah',
      pricing_calculator_url: 'https://foo.com/blah'
    }
  }

  assert_invalidity_of_blank_field :free_version
  assert_invalidity_of_blank_field :free_trial
  assert_invalidity_of_blank_field :pricing_currency
  assert_invalidity_of_blank_field :pricing_min
  assert_invalidity_of_blank_field :pricing_max
  assert_invalidity_of_blank_field :pricing_unit
  assert_invalidity_of_blank_field :pricing_variables
  assert_invalidity_of_blank_field :education_pricing
  assert_invalidity_of_blank_field :not_for_profit_pricing

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

  it 'is not valid with a bad pricing calculator url' do
    subject.validate(atts.merge(pricing_calculator_url: 'foo'))

    expect(subject).to_not be_valid
  end

  it 'is not valid with an invalid currency' do
    subject.validate(atts.merge(pricing_currency: 'other', pricing_currency_other: 'blah'))

    expect(subject).to_not be_valid
  end
end
