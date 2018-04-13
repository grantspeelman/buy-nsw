require 'rails_helper'

RSpec.describe Ops::BuyersController, type: :controller, sign_in: :admin_user do

  describe 'POST deactivate' do

    let(:buyer) { create(:active_buyer) }

    describe 'on success' do

      it 'redirects to the buyer page' do
        post :deactivate, params: { id: buyer.id }

        expect(response).to redirect_to(ops_buyer_path(buyer))
      end

      it 'sets a success flash notice' do
        expect(I18n).to receive(:t).with(/deactivate_success$/).and_return('String')

        post :deactivate, params: { id: buyer.id }

        expect(controller.flash.notice).to eq('String')
      end
    end

  end

end
