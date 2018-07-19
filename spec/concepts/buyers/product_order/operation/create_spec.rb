require 'rails_helper'

RSpec.describe Buyers::ProductOrder::Create::Present do
  include ActiveJob::TestHelper

  let(:product) { create(:active_product) }
  let(:buyer_user) { create(:active_buyer_user) }
  let(:valid_atts) {
    {
      estimated_contract_value: '123000',
      contacted_seller: true,
      purchased_cloud_before: true,
    }
  }

  def perform_operation(user: buyer_user, product_id: product.id, params: valid_atts)
    described_class.({ id: product_id, product_order: params }, { 'config.current_user' => user })
  end

  context 'failure states' do
    it 'fails when the current user is blank' do
      operation = perform_operation(user: nil)

      expect(operation).to be_failure
    end

    it 'fails when the current user is not a buyer' do
      user = create(:seller_user)
      operation = perform_operation(user: user)

      expect(operation).to be_failure
    end

    it 'fails when the current user does not have a buyer record' do
      user = create(:user, roles: ['buyer'])
      operation = perform_operation(user: user)

      expect(operation).to be_failure
    end

    it 'fails when the current user is an inactive buyer' do
      user = create(:buyer_user)
      create(:inactive_buyer, user: user)
      operation = perform_operation(user: user)

      expect(operation).to be_failure
    end

    it 'fails when the product is blank' do
      expect {
        perform_operation(product_id: nil)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'fails when the product is inactive' do
      product = create(:inactive_product)

      expect {
        perform_operation(product_id: product.id)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

end
