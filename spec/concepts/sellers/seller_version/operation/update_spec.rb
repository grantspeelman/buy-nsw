require 'rails_helper'

RSpec.describe Sellers::SellerVersion::Update do

  let(:seller_version) { create(:created_seller_version) }
  let(:abn) { attributes_for(:created_seller_version_with_profile)[:abn] }

  let(:current_user) { create(:user, seller: seller_version.seller) }
  let(:default_params) {
    { name: 'Company', abn: abn }
  }
  let(:default_contract) { Sellers::SellerVersion::Contract::BusinessDetails }

  def perform_operation(user: current_user, params: default_params, contract: default_contract)
    described_class.(
      { id: seller_version.id, seller_application: params },
      'config.current_user' => user,
      'config.contract_class' => contract
    )
  end

  it 'saves the seller application' do
    result = perform_operation

    expect(result).to be_success

    expect(result['model.seller_version']).to be_persisted
    expect(result['model.seller']).to be_persisted

    expect(seller_version.reload.name).to eq('Company')
  end

  context 'for legals' do
    let(:contract) {
      Sellers::SellerVersion::Contract::Declaration
    }

    def fill_required_details(email: current_user.email)
      seller_version.update_attributes!(
        name: 'Seller name',
        abn: '12 345 678 910',
        representative_name: 'Example',
        representative_phone: '555 1234',
        representative_position: 'Example',
        representative_email: email,
      )
    end

    it 'fails when the authorised representative is not set' do
      result = perform_operation(contract: contract)

      expect(result).to be_failure
      expect(result['result.errors']).to have_key('missing_representative_details')
    end

    it 'fails when the business details are not set' do
      result = perform_operation(contract: contract)

      expect(result).to be_failure
      expect(result['result.errors']).to have_key('missing_business_details')
    end

    it 'fails when the user is not the authorised representative' do
      fill_required_details(email: 'blah@dev.test.nsw.gov.au')
      result = perform_operation(contract: contract)

      expect(result).to be_failure
      expect(result['result.errors']).to have_key('not_authorised_representative')
    end

    it 'is successful when the user is the authorised representative' do
      fill_required_details
      result = perform_operation(
        contract: contract,
        params: { agree: '1' }
      )

      expect(result).to be_success
      expect(seller_version.reload.agree).to be_truthy
    end

    it 'sets the agreed_at and agreed_by attributes' do
      fill_required_details

      time = Time.now
      Timecop.freeze(time) do
        perform_operation(
          contract: contract,
          params: { agree: '1' }
        )
      end

      seller_version.reload

      expect(seller_version.agreed_by).to eq(current_user)
      expect(seller_version.agreed_at.to_i).to eq(time.to_i)
    end
  end
end
