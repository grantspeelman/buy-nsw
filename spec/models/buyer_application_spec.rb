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

        expect(application.state).to eq('assigned')
      end

      it 'transitions to `approved` when email approval is not required and the buyer is an employee' do
        application.user.email = 'foo@example.nsw.gov.au'
        application.buyer.employment_status = 'employee'
        application.submit

        expect(application.state).to eq('approved')
      end
    end

    describe '#assign' do
      let(:application) { create(:awaiting_assignment_buyer_application) }

      it 'transitions from `awaiting_assignment` to `assigned`' do
        application.assign

        expect(application.state).to eq('assigned')
      end
    end

    describe '#approve' do
      let(:application) { create(:assigned_buyer_application) }

      it 'transitions from `assigned` to `approved`' do
        application.approve

        expect(application.state).to eq('approved')
      end
    end

    describe '#reject' do
      let(:application) { create(:assigned_buyer_application) }

      it 'transitions from `assigned` to `rejected`' do
        application.reject

        expect(application.state).to eq('rejected')
      end
    end

  end

end
