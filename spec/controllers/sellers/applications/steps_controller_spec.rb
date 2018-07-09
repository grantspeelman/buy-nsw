require 'rails_helper'

RSpec.describe Sellers::Applications::StepsController, type: :controller, sign_in: :seller_user_with_seller do

  describe '.contracts' do
    context 'given a seller who does not offer cloud services' do
      let(:seller_version) { create(:created_seller_version, services: []) }

      it 'excludes the declaration' do
        contracts = described_class.contracts(seller_version)
        expect(contracts).to_not include(Sellers::SellerVersion::Contract::Declaration)
      end
    end

    context 'given a seller who offers cloud services' do
      let(:seller_version) { create(:created_seller_version, services: ['cloud-services']) }

      it 'includes the declaration' do
        contracts = described_class.contracts(seller_version)
        expect(contracts).to include(Sellers::SellerVersion::Contract::Declaration)
      end
    end
  end

  describe '.steps' do
    let(:seller_version) { create(:created_seller_version) }

    it 'returns instances of Sellers::Applications::StepPresenter' do
      steps = described_class.steps(seller_version)
      expect(steps.first).to be_a(Sellers::Applications::StepPresenter)
    end
  end

end
