require 'rails_helper'

RSpec.describe Buyers::BaseController do

  describe '#validate_active_buyer!' do
    before(:each) { bypass_rescue }

    controller(Buyers::BaseController) do
      before_action :validate_active_buyer!

      def index
        head :ok
      end
    end

    context 'when there is no signed in user' do
      it 'raises an exception' do
        expect { get :index }.to raise_error(ApplicationController::NotAuthorized)
      end
    end

    context 'when the user is not an active buyer', sign_in: :user do
      before(:each) {
        expect_any_instance_of(User).to receive(:is_active_buyer?).and_return(false)
      }

      it 'raises an exception' do
        expect { get :index }.to raise_error(ApplicationController::NotAuthorized)
      end
    end

    context 'when the user is an active buyer', sign_in: :user do
      before(:each) {
        expect_any_instance_of(User).to receive(:is_active_buyer?).and_return(true)
      }

      it 'performs the action' do
        get :index
        expect(response).to have_http_status(:ok)
      end
    end
  end

end
