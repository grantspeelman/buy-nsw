require 'rails_helper'

RSpec.describe Buyers::BuyerApplication::Update do
  include ActiveJob::TestHelper

  let(:user) { create(:buyer_user_without_approved_email) }

  let(:buyer) { create(:buyer, user: user) }
  let(:application) { create(:created_buyer_application, buyer: buyer) }

  def build_params(application, step, params = {})
    {
      id: application.id,
      step: step,
      buyer_application: params,
    }
  end

  before :each do
    allow(SlackPostJob).to receive(:perform_later)    
  end

  it 'can save a buyer given a step and valid attributes' do
    result = Buyers::BuyerApplication::Update.(
               build_params(application, 'basic-details', {
                 name: 'John Doe',
                 organisation: 'Organisation Name',
               }),
               'current_user' => user,
             )
    result[:buyer_model].reload

    expect(result).to be_success
    expect(result[:buyer_model].name).to eq('John Doe')
  end

  context '#submit_if_valid_and_last_step!' do
    it 'does not submit an application when a contract is invalid' do
      # NOTE: The application here is inherited from above but is invalid for
      # submission
      result = Buyers::BuyerApplication::Update.(
                 build_params(application, 'terms'),
                 'current_user' => user,
               )
      result[:application_model].reload

      # NOTE: Expect this to be a success as it is still persisted even when
      # invalid.
      expect(result).to be_success

      expect(result['result.submitted']).to be_falsey
      expect(result[:application_model].state).to eq('created')
    end

    it 'submits an application on the last step when all fields are valid' do
      buyer = create(:inactive_completed_buyer, user: user)
      application = create(:created_buyer_application, buyer: buyer)

      result = Buyers::BuyerApplication::Update.(
                 build_params(application, 'terms'),
                 'current_user' => user,
               )
      result[:application_model].reload

      expect(result).to be_success
      expect(result['result.submitted']).to be_truthy
      expect(result[:application_model].state).to eq('awaiting_assignment')
      expect(result[:application_model].events.last.message).to eq('Submitted application')
      expect(result[:application_model].events.last.user).to eq(user)
    end

    it 'sets the token when manager approval is required' do
      buyer = create(:inactive_completed_contractor_buyer, user: user)
      application = create(:created_manager_approval_buyer_application, buyer: buyer)

      result = Buyers::BuyerApplication::Update.(
                 build_params(application, 'terms'),
                 'current_user' => user,
               )
      result[:application_model].reload

      expect(result).to be_success
      expect(result[:application_model].manager_approval_token).to be_present
    end

    it 'sends an email when manager approval is required' do
      buyer = create(:inactive_completed_contractor_buyer, user: user)
      application = create(:created_manager_approval_buyer_application, buyer: buyer)

      expect {
        perform_enqueued_jobs do
          Buyers::BuyerApplication::Update.(
            build_params(application, 'terms'),
            'current_user' => user,
          )
        end
      }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end

  context '#next_step!' do
    it 'writes the next step slug to the result object' do
      result = Buyers::BuyerApplication::Update.(
                 build_params(application, 'basic-details'),
                 'current_user' => user,
               )

      expect(result['result.next_step_slug']).to eq('email-approval')
    end

    it 'returns the first step slug when the next slug does not exist' do
      result = Buyers::BuyerApplication::Update.(
                 build_params(application, 'terms'),
                 'current_user' => user,
               )

      expect(result['result.next_step_slug']).to eq('basic-details')
    end
  end

  context '#set_submission_status!' do
    it 'sets the `ready_for_submission` flag to `true` when all steps aside from the last are valid' do
      buyer = create(:inactive_completed_buyer, user: user)
      application = create(:created_buyer_application, buyer: buyer)

      result = Buyers::BuyerApplication::Update::Present.(
                 build_params(application, 'terms'),
                 'current_user' => user,
               )

      expect(result['result.ready_for_submission']).to be_truthy
    end

    it 'sets the `ready_for_submission` flag to `false` when a step that is not the last is invalid' do
      buyer = create(:buyer, user: user)
      application = create(:created_buyer_application, buyer: buyer)

      result = Buyers::BuyerApplication::Update::Present.(
                 build_params(application, 'terms'),
                 'current_user' => user,
               )

      expect(result['result.ready_for_submission']).to be_falsey
    end
  end

end
