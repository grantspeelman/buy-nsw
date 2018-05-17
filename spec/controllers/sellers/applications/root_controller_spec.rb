require 'rails_helper'

RSpec.describe Sellers::Applications::RootController, type: :controller, sign_in: :seller_user_with_seller do

  it 'redirects to the tailor step for an untailored application' do
    application = create(:created_seller_application,
      seller: @user.seller,
      tailor_complete: false)

    get :show, params: { id: application.id }

    expect(response).to redirect_to(
      tailor_sellers_application_path(application.id)
    )
  end

  it 'renders a 404 for an application not owned by the user' do
    other_seller = create(:seller)
    other_application = create(:created_seller_application,
      seller: other_seller,
      tailor_complete: false)

    get :show, params: { id: other_application.id }

    expect(response).to have_http_status(:not_found)
  end

end
