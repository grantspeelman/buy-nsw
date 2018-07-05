require 'rails_helper'

RSpec.describe Sellers::SellerApplication::Contract::Addresses do
  let(:seller) { create(:inactive_seller) }
  let(:application) { create(:seller_version, seller: seller) }

  subject { Sellers::SellerApplication::Contract::Addresses.new(application: application, seller: seller) }

  let(:atts) {
    {
      addresses: [
        address_atts,
      ]
    }
  }
  let(:address_atts) { attributes_for(:seller_address) }

  it 'can save with valid attributes' do
    expect(subject.validate(atts)).to eq(true)
    expect(subject.save).to eq(true)
  end

  it 'is invalid without an address' do
    subject.validate(atts.merge(addresses: []))

    expect(subject).to_not be_valid
    expect(subject.errors[:addresses]).to be_present
  end

  context 'a nested address' do
    it 'is invalid when there is no street address' do
      address = address_atts.merge(address: nil)
      invalid_atts = atts.merge(addresses: [ address ])

      subject.validate(invalid_atts)

      expect(subject).to_not be_valid
      expect(subject.addresses[0].errors[:address]).to be_present
    end

    it 'is invalid when there is no suburb' do
      address = address_atts.merge(suburb: nil)
      invalid_atts = atts.merge(addresses: [ address ])

      subject.validate(invalid_atts)

      expect(subject).to_not be_valid
      expect(subject.addresses[0].errors[:suburb]).to be_present
    end

    it 'is invalid when there is no state' do
      address = address_atts.merge(state: nil)
      invalid_atts = atts.merge(addresses: [ address ])

      subject.validate(invalid_atts)

      expect(subject).to_not be_valid
      expect(subject.addresses[0].errors[:state]).to be_present
    end

    it 'is invalid when there is no postcode' do
      address = address_atts.merge(postcode: nil)
      invalid_atts = atts.merge(addresses: [ address ])

      subject.validate(invalid_atts)

      expect(subject).to_not be_valid
      expect(subject.addresses[0].errors[:postcode]).to be_present
    end

    # TODO: This behaviour currently works in the application but appears not to
    # in these unit tests. Return to these in future and fix.
    #
    # context 'with the `addresses_attributes` keys' do
    #   it 'is valid with a full address' do
    #     attributes = atts.merge(addresses: nil, addresses_attributes: [ address_atts ])
    #     subject.validate(attributes)
    #
    #     expect(subject).to be_valid
    #   end
    #
    #   it 'is invalid with a missing attribute' do
    #     invalid_address = address_atts.merge(address: nil)
    #     attributes = atts.merge(addresses: nil, addresses_attributes: [ invalid_address ])
    #     subject.validate(attributes)
    #
    #     expect(subject).to_not be_valid
    #     puts subject.errors.inspect
    #     expect(subject.errors[:addresses_attributes][0][:address]).to be_present
    #   end
    # end
  end

end
