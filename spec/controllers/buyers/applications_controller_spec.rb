require 'rails_helper'

RSpec.describe Buyers::ApplicationsController do

  describe 'GET manager_approve' do

    let(:application) { create(:buyer_application) }
    let(:operation) {
      { 'result.approved' => true }
    }

    it 'invokes the operation' do
      expect(controller).to receive(:run).and_return(operation)
      get :manager_approve, params: { id: application.id }

      expect(controller.send(:operation)['result.approved']).to be_truthy
    end

    it 'redirects to the root_path' do
      expect(controller).to receive(:run).and_return(operation)
      get :manager_approve, params: { id: application.id }

      expect(response).to redirect_to(root_path)
    end

    it 'sets a success flash notice when the operation is successful' do
      expect(I18n).to receive(:t).with(/manager_approve_success$/).and_return('String')
      expect(controller).to receive(:run).and_return(operation)

      get :manager_approve, params: { id: application.id }

      expect(controller.flash.notice).to eq('String')
    end

    it 'sets a failure flash notice when the operation failed' do
      failed_op = { 'result.approved' => false }

      expect(I18n).to receive(:t).with(/manager_approve_failure$/).and_return('String')
      expect(controller).to receive(:run).and_return(failed_op)

      get :manager_approve, params: { id: application.id }

      expect(controller.flash.notice).to eq('String')
    end

  end

end
