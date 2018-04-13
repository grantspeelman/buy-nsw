require 'rails_helper'

RSpec.describe Ops::Buyer::Deactivate do

  let(:buyer) { create(:active_buyer) }

  it 'changes the state of a buyer to `inactive`' do
    result = Ops::Buyer::Deactivate.({ id: buyer.id })

    expect(result).to be_success
    expect(buyer.reload.state).to eq('inactive')
  end

  it 'fails when the buyer cannot move to the `inactive` state' do
    buyer = create(:inactive_buyer)
    result = Ops::Buyer::Deactivate.({ id: buyer.id })

    expect(result).to be_failure
  end

end
