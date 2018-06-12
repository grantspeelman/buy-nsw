require 'rails_helper'

RSpec.describe SellerDecorator do

  let(:seller) { create(:seller) }
  let(:mock_context) { double('view context') }

  subject { SellerDecorator.new(seller, mock_context) }

  describe '#addresses' do
    it 'returns addresses wrapped in decorator objects' do
      create_list(:seller_address, 3, seller: seller)

      expect(subject.addresses.size).to eq(3)
      subject.addresses.each do |address|
        expect(address).to be_a(SellerAddressDecorator)
      end
    end
  end

end
