require 'rails_helper'

RSpec.describe Ops::AssignBuyerApplication do

  let(:application) { create(:awaiting_assignment_buyer_application) }

  let(:current_user) { create(:admin_user) }
  let(:assignee_user) { create(:admin_user) }

  let(:valid_attributes) {
    { assigned_to_id: assignee_user.id }
  }

  describe '.call' do
    def perform_operation(attributes: valid_attributes)
      described_class.call(
        buyer_application_id: application.id,
        current_user: current_user,
        attributes: attributes,
      )
    end

    context 'with valid attributes' do
      let!(:operation) { perform_operation }

      it 'is successful' do
        expect(operation).to be_success
        expect(operation).to_not be_failure
      end

      it 'assigns a user to the application' do
        expect(operation.buyer_application.assigned_to).to eq(assignee_user)
      end

      it 'transitions to the "ready_for_review" state' do
        expect(operation.buyer_application.state).to eq('ready_for_review')
      end

      it 'logs an event' do
        expect(application.events.first.user).to eq(current_user)
        expect(application.events.first.message).to eq("Assigned application to #{assignee_user.email}")
      end
    end

    context 'a "ready_for_review" application' do
      let(:application) { create(:ready_for_review_buyer_application) }
      let!(:operation) { perform_operation }

      it 'stays in the "ready_for_review_state"' do
        expect(operation.buyer_application.state).to eq('ready_for_review')
      end
    end

    context 'an application in another state' do
      let(:application) { create(:created_buyer_application) }
      let!(:operation) { perform_operation }

      it 'does not transition the state' do
        expect(operation.buyer_application.state).to eq('created')
      end
    end

    context 'with invalid attributes' do
      let!(:operation) { perform_operation(attributes: { assigned_to_id: nil }) }

      it 'fails' do
        expect(operation).to be_failure
      end
    end

    context 'when the BuildAssignBuyerApplication service fails' do
      before(:each) do
        expect(Ops::BuildAssignBuyerApplication).to receive(:call).
          with(buyer_application_id: application.id).
          and_return(
            double(success?: false, failure?: true)
          )
      end

      it 'fails' do
        expect(perform_operation).to be_failure
      end
    end
  end

end
