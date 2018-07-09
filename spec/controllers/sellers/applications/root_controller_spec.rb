require 'rails_helper'

RSpec.describe Sellers::Applications::RootController, type: :controller, sign_in: :seller_user_with_seller do

  describe 'GET show' do
    context 'for a seller version not owned by the user' do
      let!(:other_seller) { create(:seller) }
      let!(:other_version) { create(:created_seller_version, seller: other_seller) }

      it 'returns a not found status' do
        get :show, params: { id: other_version.id }
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'for a seller version owned by the user' do
      let!(:seller_version) { create(:created_seller_version, seller: @user.seller) }

      it 'returns an OK status' do
        get :show, params: { id: seller_version.id }
        expect(response).to have_http_status(:ok)
      end
    end
  end

end
