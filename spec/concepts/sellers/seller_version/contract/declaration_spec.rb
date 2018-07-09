require 'rails_helper'

RSpec.describe Sellers::SellerVersion::Contract::Declaration do

  let(:seller_version) { create(:seller_version) }
  subject { described_class.new(seller_version: seller_version, seller: seller_version.seller) }

  it 'can save with terms acceptance' do
    subject.validate({
      agree: true
    })

    expect(subject).to be_valid
    expect(subject.save).to eq(true)
  end

  it 'is invalid when terms are not accepted' do
    subject.validate({
      agree: false
    })

    expect(subject).to_not be_valid
    expect(subject.errors[:agree]).to be_present
  end

  describe '#representative_details_provided?' do
    context 'when all details are provided' do
      before(:each) do
        seller_version.update_attributes(
          representative_name: 'Name',
          representative_email: 'Email',
          representative_phone: '01253 123456',
          representative_position: 'Position',
        )
      end

      it 'returns true' do
        expect(subject.representative_details_provided?).to be_truthy
      end
    end

    context 'when details are missing' do
      before(:each) do
        seller_version.update_attributes(
          representative_name: 'Name',
          representative_email: nil,
          representative_phone: nil,
          representative_position: nil,
        )
      end

      it 'returns true' do
        expect(subject.representative_details_provided?).to be_falsey
      end
    end
  end

  describe '#business_details_provided?' do
    context 'when all details are provided' do
      before(:each) do
        seller_version.update_attributes(
          name: 'Name',
          abn: 'ABN',
        )
      end

      it 'returns true' do
        expect(subject.business_details_provided?).to be_truthy
      end
    end

    context 'when details are missing' do
      before(:each) do
        seller_version.update_attributes(
          name: 'Name',
          abn: nil,
        )
      end

      it 'returns true' do
        expect(subject.business_details_provided?).to be_falsey
      end
    end
  end
end
