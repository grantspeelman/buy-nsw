require 'rails_helper'

RSpec.describe Buyer do

  describe 'state changes' do

    describe '#make_active' do
      let(:buyer) { create(:inactive_buyer) }

      it 'transitions from `inactive` to `active`' do
        expect { buyer.make_active }.to change { buyer.state }.from('inactive').to('active')
      end
    end

    describe '#make_inactive' do
      let(:buyer) { create(:active_buyer) }

      it 'transitions from `active` to `inactive`' do
        expect { buyer.make_inactive }.to change { buyer.state }.from('active').to('inactive')
      end
    end
    
  end

end
