require 'rails_helper'

RSpec.describe BuyerApplication do

  describe 'state changes' do
    describe '#submit' do
      let(:application) { create(:buyer_application) }

      it 'transitions to `awaiting_manager_approval` when the buyer is a contractor' do
        application.buyer.employment_status = 'contractor'
        application.submit

        expect(application.state).to eq('awaiting_manager_approval')
      end

      it 'transitions to `awaiting_assignment` when email approval is required, but no assignee is present' do
        application.user.email = 'foo@outside.org'
        application.submit

        expect(application.state).to eq('awaiting_assignment')
      end

      it 'transitions to `assigned` when email approval is required and an assignee is present' do
        application.user.email = 'foo@outside.org'
        application.assigned_to = create(:admin_user)
        application.submit

        expect(application.state).to eq('ready_for_review')
      end

      # NOTE: This behaviour has been removed for launch.
      #
      # it 'transitions to `approved` when email approval is not required and the buyer is an employee' do
      #   application.user.email = 'foo@example.nsw.gov.au'
      #   application.buyer.employment_status = 'employee'
      #   application.submit
      #
      #   expect(application.state).to eq('approved')
      # end
    end

    describe '#manager_approve' do
      let(:application) { create(:awaiting_manager_approval_buyer_application) }

      it 'transitions to `awaiting_assignment` when email approval is required and no assignee is present' do
        application.user.email = 'foo@outside.org'
        application.manager_approve

        expect(application.state).to eq('awaiting_assignment')
      end

      it 'transitions to `assigned` when email approval is required and an assignee is present' do
        application.user.email = 'foo@outside.org'
        application.assigned_to = create(:admin_user)
        application.manager_approve

        expect(application.state).to eq('ready_for_review')
      end

      # NOTE: This behaviour has been removed for launch.
      #
      # it 'transitions to `approved` when email approval is not required' do
      #   application.user.email = 'foo@example.nsw.gov.au'
      #   application.manager_approve
      #
      #   expect(application.state).to eq('approved')
      # end
    end

    describe '#assign' do
      let(:application) { create(:awaiting_assignment_buyer_application) }

      it 'transitions from `awaiting_assignment` to `assigned`' do
        application.assign

        expect(application.state).to eq('ready_for_review')
      end
    end

    describe '#approve' do
      let(:application) { create(:ready_for_review_buyer_application) }

      it 'transitions from `assigned` to `approved`' do
        application.approve

        expect(application.state).to eq('approved')
      end

      it 'transitions the buyer to `active`' do
        expect { application.approve! }.to change {
          application.buyer.reload.state
        }.from('inactive').to('active')
      end
    end

    describe '#reject' do
      let(:application) { create(:ready_for_review_buyer_application) }

      it 'transitions from `assigned` to `rejected`' do
        application.reject

        expect(application.state).to eq('rejected')
      end
    end
  end

  describe '#set_manager_approval_token!' do
    it 'persists a new random token in the `manager_approval_token` field' do
      application = create(:buyer_application)
      expect(SecureRandom).to receive(:hex).and_return('random string')

      application.set_manager_approval_token!
      application.reload

      expect(application.manager_approval_token).to eq('random string')
    end
  end

end
