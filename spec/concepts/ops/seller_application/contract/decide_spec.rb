require 'rails_helper'

RSpec.describe Ops::SellerApplication::Contract::Decide do

  let(:application) { create(:seller_application) }

  it 'is valid with a decision and response' do
    form = Ops::SellerApplication::Contract::Decide.new(application)

    form.validate(
       decision: 'approve',
       response: 'Response',
    )

    expect(form).to be_valid
  end

  it 'is invalid without a decision' do
    form = Ops::SellerApplication::Contract::Decide.new(application)

    form.validate(
       decision: nil,
    )

    expect(form).to_not be_valid
    expect(form.errors[:decision]).to be_present
  end

  it 'is invalid without a decision in the list' do
    form = Ops::SellerApplication::Contract::Decide.new(application)

    form.validate(
       decision: 'blah',
    )

    expect(form).to_not be_valid
    expect(form.errors[:decision]).to be_present
  end

end
