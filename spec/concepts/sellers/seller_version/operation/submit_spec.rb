require 'rails_helper'

RSpec.describe Sellers::SellerVersion::Submit do

  let(:application) { create(:created_seller_version) }
  let(:current_user) { create(:user, seller: application.seller) }

  def perform_operation
    described_class.({ id: application.id }, 'config.current_user' => current_user)
  end

  it 'fails if the seller application is not complete' do
    expect_any_instance_of(SellerApplicationProgressReport).to receive(:all_steps_valid?).and_return(false)
    result = perform_operation

    expect(result).to be_failure
  end

  describe 'given a complete application' do
    before {
      expect_any_instance_of(SellerApplicationProgressReport).to receive(:all_steps_valid?).and_return(true)
    }

    it 'is successful if the application is in a valid state' do
      result = perform_operation

      expect(result).to be_success
      expect(application.reload.state).to eq('awaiting_assignment')
    end

    it 'fails if the application state cannot be transitioned' do
      approved_application = create(:approved_seller_version)
      current_user = create(:user, seller: approved_application.seller)

      result = described_class.(
        { id: approved_application.id },
        'config.current_user' => current_user,
      )

      expect(result).to be_failure
    end

    it 'sets the submitted_at timestamp' do
      time = 1.hour.ago

      Timecop.freeze(time) do
        perform_operation
      end
      application.reload

      expect(application.submitted_at.to_i).to eq(time.to_i)
    end

    it 'logs an event' do
      perform_operation
      application.reload

      expect(application.events.first.user).to eq(current_user)
      expect(application.events.first.message).to eq("Submitted application")
    end
  end
end
