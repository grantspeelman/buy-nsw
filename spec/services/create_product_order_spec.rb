require 'rails_helper'

RSpec.describe CreateProductOrder do
  include ActiveJob::TestHelper

  let(:product) { create(:active_product) }
  let(:buyer_user) { create(:active_buyer_user) }
  let(:valid_atts) {
    {
      estimated_contract_value: 123000,
      contacted_seller: true,
      purchased_cloud_before: true,
    }
  }

  describe '#call' do
    def perform_operation(user: buyer_user, product_id: product.id, attributes: valid_atts)
      CreateProductOrder.call(
        user: user,
        product_id: product_id,
        attributes: attributes,
      )
    end

    context 'with valid parameters' do
      it 'creates a product order' do
        expect{ perform_operation }.to change{ ProductOrder.count }.from(0).to(1)
      end

      it 'sets the buyer from the current user' do
        order = perform_operation.product_order

        expect(order.buyer).to eq(buyer_user.buyer)
      end

      it 'sets the product from the given ID' do
        order = perform_operation.product_order

        expect(order.product).to eq(product)
      end

      it 'sets the product_updated_at timestamp' do
        product.update_attribute(:updated_at, 5.days.ago)
        order = perform_operation.product_order

        expect(order.product_updated_at.to_i).to eq(product.updated_at.to_i)
      end

      it 'sets the attributes' do
        order = perform_operation.product_order

        expect(order.estimated_contract_value.to_i).to eq(valid_atts[:estimated_contract_value])
        expect(order.contacted_seller).to eq(valid_atts[:contacted_seller])
        expect(order.purchased_cloud_before).to eq(valid_atts[:purchased_cloud_before])
      end

      it 'sends an email' do
        allow(SlackPostJob).to receive(:perform_later)

        expect {
          perform_enqueued_jobs do
            perform_operation
          end
        }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it 'notifies slack of the new order' do
        expect(SlackPostJob).to receive(:perform_later)
        perform_operation
      end
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

      it 'fails when an attribute is invalid' do
        operation = perform_operation(
          attributes: valid_atts.merge(estimated_contract_value: nil)
        )

        expect(operation).to be_failure
      end
    end
  end

end
