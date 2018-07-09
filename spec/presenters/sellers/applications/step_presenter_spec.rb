require 'rails_helper'

RSpec.describe Sellers::Applications::StepPresenter do

  let(:seller_version) { create(:created_seller_version) }
  let(:contract) { Sellers::SellerVersion::Contract::BusinessDetails }

  subject { described_class.new(contract) }

  describe '#started?' do
    before(:each) do
      allow(contract).to receive(:new).with(
        seller_version: seller_version,
        seller: seller_version.seller
      ).and_return(mock_contract)
    end

    context 'when the contract is started' do
      let(:mock_contract) { double('contract', started?: true) }

      it 'returns true' do
        expect(subject.started?(seller_version)).to be_truthy
      end
    end

    context 'when the contract has not been started' do
      let(:mock_contract) { double('contract', started?: false) }

      it 'returns true' do
        expect(subject.started?(seller_version)).to be_falsey
      end
    end
  end

  describe '#complete?' do
    before(:each) do
      allow(contract).to receive(:new).with(
        seller_version: seller_version,
        seller: seller_version.seller
      ).and_return(mock_contract)
    end

    context 'when validate_optional_steps is false' do
      def invoke_method
        subject.complete?(seller_version, validate_optional_steps: false)
      end

      context 'when the contract is started and valid' do
        let(:mock_contract) { double('contract', valid?: true, started?: true) }

        it 'returns true' do
          expect(invoke_method).to be_truthy
        end
      end

      context 'when the contract is not started' do
        let(:mock_contract) { double('contract', started?: false) }

        it 'returns false' do
          expect(invoke_method).to be_falsey
        end
      end

      context 'when the contract is not valid' do
        let(:mock_contract) { double('contract', valid?: false, started?: true) }

        it 'returns false' do
          expect(invoke_method).to be_falsey
        end
      end
    end

    context 'when validate_optional_steps is true' do
      def invoke_method
        subject.complete?(seller_version, validate_optional_steps: true)
      end

      context 'when the contract is valid' do
        let(:mock_contract) { double('contract', valid?: true) }

        it 'returns true' do
          expect(invoke_method).to be_truthy
        end
      end

      context 'when the contract is not valid' do
        let(:mock_contract) { double('contract', valid?: false) }

        it 'returns false' do
          expect(invoke_method).to be_falsey
        end
      end
    end
  end

end
