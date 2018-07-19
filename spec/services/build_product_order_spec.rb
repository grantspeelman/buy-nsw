require 'rails_helper'

RSpec.describe BuildProductOrder do

  let(:product) { create(:active_product) }
  let(:buyer_user) { create(:active_buyer_user) }

  subject { described_class.new(user: buyer_user, product_id: product.id) }

  describe '.call' do
    def perform_operation(user: buyer_user, product_id: product.id)
      BuildProductOrder.call(
        user: user,
        product_id: product_id,
      )
    end

    context 'with a valid product and buyer' do
      it 'is sucessful' do
        expect(perform_operation).to be_success
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
    end
  end

  describe '#form' do
    it 'returns a form for the product order' do
      expect(subject.form).to be_a(Buyers::ProductOrder::Contract::Create)
      expect(subject.form.model).to be_a(ProductOrder)
    end
  end

  describe '#product' do
    it 'returns the product' do
      expect(subject.product).to eq(product)
    end
  end

  describe '#buyer' do
    it 'returns the buyer' do
      expect(subject.buyer).to eq(buyer_user.buyer)
    end
  end

  describe '#product_order' do
    it 'builds a new product order' do
      expect(subject.product_order).to be_a(ProductOrder)
      expect(subject.product_order.product).to eq(product)
    end
  end

end
