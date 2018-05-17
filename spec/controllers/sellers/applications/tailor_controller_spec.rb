require 'rails_helper'

RSpec.describe Sellers::Applications::TailorController, type: :controller, sign_in: :seller_user_with_seller do

  it 'redirects to the root step for a tailored application' do
    application = create(:created_seller_application,
      seller: @user.seller,
      tailor_complete: true)

    get :show, params: { id: application.id }

    expect(response).to redirect_to(
      sellers_application_path(application.id)
    )
  end

  it 'renders the page for an untailored application' do
    application = create(:created_seller_application,
      seller: @user.seller,
      tailor_complete: false)

    get :show, params: { id: application.id }

    expect(response).to have_http_status(:ok)
  end

end
