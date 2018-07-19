require 'rails_helper'

RSpec.describe Ops::DecideBuyerApplication do
  include ActiveJob::TestHelper

  let(:application) { create(:ready_for_review_buyer_application) }
  let(:current_user) { create(:admin_user) }

  describe '.call' do
    def perform_operation(attributes:)
      described_class.call(
        buyer_application_id: application.id,
        current_user: current_user,
        attributes: attributes,
      )
    end

    context 'approving an application' do
      let(:operation) {
        perform_operation(attributes: {
          decision: 'approve',
          decision_body: 'Response',
        })
      }

      it 'is successful' do
        expect(operation).to be_success
        expect(operation).to_not be_failure
      end

      it 'transitions to the "approved" state' do
        expect(operation.buyer_application.state).to eq('approved')
      end

      it 'logs an event' do
        expect(operation.buyer_application.events.first.user).to eq(current_user)
        expect(operation.buyer_application.events.first.message).to eq("Approved application. Response: Response")
      end

      it 'sends an email' do
        expect {
          perform_enqueued_jobs { operation }
        }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it 'sets a timestamp' do
        time = Time.now

        Timecop.freeze(time) do
          operation
        end

        expect(operation.buyer_application.decided_at.to_i).to eq(time.to_i)
      end
    end

    context 'rejecting an application' do
      let(:operation) {
        perform_operation(attributes: {
          decision: 'reject',
          decision_body: 'Response',
        })
      }

      it 'is successful' do
        expect(operation).to be_success
      end

      it 'transitions to the "rejected" state' do
        expect(operation.buyer_application.state).to eq('rejected')
      end

      it 'logs an event' do
        expect(operation.buyer_application.events.first.user).to eq(current_user)
        expect(operation.buyer_application.events.first.message).to eq("Rejected application. Response: Response")
      end
    end
  end

end
