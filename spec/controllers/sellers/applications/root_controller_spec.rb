require 'rails_helper'

RSpec.describe Sellers::Applications::RootController, type: :controller, sign_in: :seller_user_with_seller do

  it 'renders a 404 for an application not owned by the user' do
    other_seller = create(:seller)
    other_application = create(:created_seller_version,
      seller: other_seller)

    get :show, params: { id: other_application.id }

    expect(response).to have_http_status(:not_found)
  end

end
