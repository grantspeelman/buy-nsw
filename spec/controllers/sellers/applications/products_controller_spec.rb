require 'rails_helper'

RSpec.describe Sellers::Applications::ProductsController, type: :controller, sign_in: :seller_user_with_seller do

  describe 'GET index' do
    context 'when the seller does not provide cloud services' do
      let!(:seller_version) { create(:created_seller_version, seller: @user.seller, services: []) }

      it 'redirects to the seller application' do
        get :index, params: { application_id: seller_version.id }
        expect(response).to have_http_status(:redirect)
      end
    end

    context 'when the seller provides cloud services' do
      let!(:seller_version) { create(:created_seller_version, seller: @user.seller, services: ['cloud-services']) }

      it 'redirects to the seller application' do
        get :index, params: { application_id: seller_version.id }
        expect(response).to have_http_status(:ok)
      end
    end
  end

end
