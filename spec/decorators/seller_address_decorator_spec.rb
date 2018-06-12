require 'rails_helper'

RSpec.describe SellerAddressDecorator do

  let(:address) { create(:seller_address) }
  let(:mock_context) { double('view context') }

  subject { SellerAddressDecorator.new(address, mock_context) }

  describe '#country' do
    it 'returns the ISO3166 translation for the country code' do
      address.country = 'GB'
      expect(subject.country).to eq('United Kingdom')
    end
  end

end
