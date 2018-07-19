require 'rails_helper'

RSpec.describe Ops::DeactivateBuyer do

  let(:buyer) { create(:active_buyer) }

  describe '.call' do
    it 'changes the state of a buyer to `inactive`' do
      result = described_class.call(buyer_id: buyer.id)

      expect(result).to be_success
      expect(buyer.reload.state).to eq('inactive')
    end

    it 'fails when the buyer cannot move to the `inactive` state' do
      buyer = create(:inactive_buyer)
      result = described_class.call(buyer_id: buyer.id)

      expect(result).to be_failure
    end
  end

end
