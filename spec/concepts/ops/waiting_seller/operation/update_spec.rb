require 'rails_helper'

RSpec.describe Ops::WaitingSeller::Update do

  let(:waiting_seller) { create(:waiting_seller) }

  it 'updates a waiting seller' do
    result = described_class.({
      id: waiting_seller.id,
      waiting_seller: attributes_for(:waiting_seller, name: 'Example'),
    })

    expect(result).to be_success
    expect(result['model'].previous_changes.keys).to be_any
  end

  it 'fails when a waiting seller does not exist' do
    expect {
      described_class.({ id: 'abc' })
    }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'fails when a waiting seller does not have an "invitation_state" of "created"' do
    waiting_seller = create(:invited_waiting_seller)

    expect {
      described_class.({ id: waiting_seller.id })
    }.to raise_error(ActiveRecord::RecordNotFound)
  end

end
