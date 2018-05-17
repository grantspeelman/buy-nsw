require 'rails_helper'

RSpec.describe Sellers::SellerApplication::Tailor::Update do

  subject { Sellers::SellerApplication::Tailor::Update }

  def build_params(application, step, params = {})
    {
      id: application.id,
      step: step,
      seller_application: params,
    }
  end

  context '#set_application_status_if_complete!' do
    let(:user) { create(:seller_user) }

    let(:valid_seller) { create(:inactive_seller_with_tailor_fields, owner: user) }
    let(:invalid_seller) { create(:inactive_seller, owner: user) }

    it 'sets tailor_complete to true when valid and complete' do
      application = create(:created_seller_application, seller: valid_seller)

      result = Sellers::SellerApplication::Tailor::Update.(
                 build_params(application, 'review'),
                 'current_user' => user,
               )
      application.reload

      expect(application.tailor_complete).to be_truthy
    end

    it 'does not set tailor_complete to true when incomplete' do
      application = create(:created_seller_application, seller: valid_seller)

      result = Sellers::SellerApplication::Tailor::Update.(
                 build_params(application, 'introduction'),
                 'current_user' => user,
               )
      application.reload

      expect(application.tailor_complete).to be_falsey
    end

    it 'does not set tailor_complete to true when invalid' do
      application = create(:created_seller_application, seller: invalid_seller)

      result = Sellers::SellerApplication::Tailor::Update.(
                 build_params(application, 'review'),
                 'current_user' => user,
               )
      application.reload

      expect(application.tailor_complete).to be_falsey
    end
  end

end
