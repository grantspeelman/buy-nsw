require 'rails_helper'

RSpec.describe Sellers::Applications::Products::InfoForm do

  let(:product) { create(:inactive_product) }

  subject { Sellers::Applications::Products::InfoForm.new(product) }

  let(:atts) {
    {
      name: 'Product-o-tron 2000',
      summary: "We name you product so you don't have to",
    }
  }

  it 'can save with valid attributes' do
    subject.validate(atts)

    expect(subject).to be_valid
    expect(subject.save).to eq(true)
  end

  it 'is invalid when the name is blank' do
    subject.validate(atts.merge(name: nil))

    expect(subject).to_not be_valid
    expect(subject.errors[:name]).to be_present
  end
end
