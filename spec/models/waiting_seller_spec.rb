require 'rails_helper'

RSpec.describe WaitingSeller, type: :model do

  let(:waiting_seller) { create(:waiting_seller) }

  describe '#invitation_state' do
    it 'is "created" by default' do
      expect(WaitingSeller.new.invitation_state).to eq('created')
    end
  end

  describe '#mark_as_invited' do
    it 'sets the invitation_state to "invited"' do
      waiting_seller.mark_as_invited

      expect(waiting_seller.invitation_state).to eq('invited')
    end
  end

  describe '#mark_as_joined' do
    let(:invited_seller) { create(:invited_waiting_seller) }

    it 'sets the invitation_state to "joined"' do
      invited_seller.mark_as_joined

      expect(invited_seller.invitation_state).to eq('joined')
    end
  end

end
