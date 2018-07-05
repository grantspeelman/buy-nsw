require 'rails_helper'

RSpec.describe Sellers::SellerApplication::Products::Update do

  subject { Sellers::SellerApplication::Products::Update }

  let(:application) { create(:created_seller_version) }
  let(:product) { create(:product, seller: application.seller) }

  let(:current_user) { create(:user, seller: application.seller) }
  let(:default_params) {
    { section: Product.section.values.first }
  }
  let(:default_contract) { Sellers::SellerApplication::Products::Contract::Type }

  def perform_operation(user: current_user, params: default_params, contract: default_contract)
    subject.(
      { id: product.id, application_id: application.id, seller_application: params },
      'config.current_user' => user,
      'config.contract_class' => contract
    )
  end

  it 'saves the product' do
    result = perform_operation

    expect(result).to be_success
    expect(result['model.product']).to be_persisted

    expect(product.reload.section).to eq(default_params[:section])
  end

  it 'saves but returns false when invalid' do
    result = perform_operation(params: { section: nil })

    expect(result).to be_failure
    expect(result['model.product']).to be_persisted
  end
end
