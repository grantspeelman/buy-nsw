require 'rails_helper'

RSpec.describe Ops::SellerVersion::Contract::Decide do

  let(:application) { create(:seller_version) }

  it 'is valid with a decision and response' do
    form = described_class.new(application)

    form.validate(
       decision: 'approve',
       response: 'Response',
    )

    expect(form).to be_valid
  end

  it 'is invalid without a decision' do
    form = described_class.new(application)

    form.validate(
       decision: nil,
    )

    expect(form).to_not be_valid
    expect(form.errors[:decision]).to be_present
  end

  it 'is invalid without a decision in the list' do
    form = described_class.new(application)

    form.validate(
       decision: 'blah',
    )

    expect(form).to_not be_valid
    expect(form.errors[:decision]).to be_present
  end

end
