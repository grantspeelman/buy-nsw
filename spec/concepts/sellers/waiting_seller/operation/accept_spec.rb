require 'rails_helper'

RSpec.describe Sellers::WaitingSeller::Accept do
  let(:waiting_seller) { create(:invited_waiting_seller) }

  def perform_operation(params = {})
    described_class.({ id: waiting_seller.invitation_token, invitation: params })
  end

  let(:default_params) {
    {
      password: 'a long secure password',
      password_confirmation: 'a long secure password',
    }
  }

  describe '::Present' do
    subject { Sellers::WaitingSeller::Accept::Present }

    it 'is successful given a valid token' do
      result = subject.({ id: waiting_seller.invitation_token })

      expect(result).to be_success
    end

    it 'assigns the model' do
      result = subject.({ id: waiting_seller.invitation_token })

      expect(result['model']).to eq(waiting_seller)
    end

    it 'it raises an exception given an invalid token' do
      expect {
        subject.({ id: 'invalid-token' })
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'it raises an exception given a token for a non-invited object' do
      other_waiting_seller = create(:waiting_seller, invitation_token: 'foo')

      expect {
        subject.({ id: other_waiting_seller.invitation_token })
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  it 'is successful given valid parameters' do
    result = perform_operation(default_params)

    expect(result).to be_success
  end

  describe '#create_user!' do
    it 'creates a user from the WaitingSeller attributes' do
      expect {
        perform_operation(default_params)
      }.to change{ User.count }.from(0).to(1)

      user = User.last
      expect(user.email).to eq(waiting_seller.contact_email)
      expect(user.roles).to contain_exactly('seller')
    end

    it 'correctly sets the password' do
      result = perform_operation(default_params)

      expect(result['user'].password).to eq(default_params[:password])
    end

    it 'auto-confirms the user' do
      result = perform_operation(default_params)

      expect(result['user'].confirmed_at).to be_present
    end

    it 'fails when the user already exists' do
      create(:user, email: waiting_seller.contact_email)
      result = perform_operation(default_params)

      expect(result).to be_failure
      expect(result['errors']).to include('user_exists')
    end

    it 'fails and passes through Devise errors when the user is invalid' do
      # Cause an error to be returned from Devise
      result = perform_operation({
        password: '',
        password_confirmation: ''
      })

      expect(result).to be_failure
      expect(result['contract.default'].errors[:password]).to be_present
    end
  end

  describe '#create_seller!' do
    it 'creates a seller from the WaitingSeller attributes' do
      expect {
        perform_operation(default_params)
      }.to change{ Seller.count }.from(0).to(1)

      seller = Seller.last

      expect(seller.name).to eq(waiting_seller.name)
      expect(seller.abn).to eq(waiting_seller.abn)
      expect(seller.contact_name).to eq(waiting_seller.contact_name)
      expect(seller.contact_email).to eq(waiting_seller.contact_email)
      expect(seller.website_url).to eq(waiting_seller.website_url)
    end

    it 'fails when the ABN already exists' do
      create(:seller, abn: waiting_seller.abn)
      result = perform_operation(default_params)

      expect(result).to be_failure
      expect(result['errors']).to include('seller_exists')
    end
  end

  describe '#create_seller_address!' do
    it 'creates a seller address from the WaitingSeller attributes' do
      expect {
        perform_operation(default_params)
      }.to change{ SellerAddress.count }.from(0).to(1)

      seller = Seller.last
      address = SellerAddress.last

      expect(address.seller).to eq(seller)

      expect(address.address).to eq(waiting_seller.address)
      expect(address.suburb).to eq(waiting_seller.suburb)
      expect(address.state).to eq(waiting_seller.state)
      expect(address.postcode).to eq(waiting_seller.postcode)
    end
  end

  describe '#create_application!' do
    it 'creates a seller application for the newly-created seller' do
      expect {
        perform_operation(default_params)
      }.to change{ SellerVersion.count }.from(0).to(1)

      seller = Seller.last
      application = SellerVersion.last

      expect(application.seller).to eq(seller)
    end

    it 'sets the "started_at" timestamp' do
      time = 1.hour.ago

      Timecop.freeze(time) do
        perform_operation(default_params)
      end
      application = SellerVersion.last

      expect(application.started_at.to_i).to eq(time.to_i)
    end
  end

  describe '#log_event!' do
    it 'logs an "application started" event' do
      result = perform_operation(default_params)

      expect(result['application'].events.last.message).to eq("Started application")
      expect(result['application'].events.last.user).to eq(result['user'])
    end
  end

  describe '#update_seller_assignment!' do
    it 'assigns the newly-created seller to the newly-created user' do
      result = perform_operation(default_params)

      expect(result['user'].seller).to eq(result['seller'])
    end
  end

  describe '#update_invitation_state!' do
    it 'updates the invitation state of the WaitingSeller' do
      expect {
        perform_operation(default_params)
      }.to change {
        waiting_seller.reload.invitation_state
      }.from('invited').to('joined')
    end

    it 'clears the invitation token' do
      perform_operation(default_params)

      expect(waiting_seller.reload.invitation_token).to be_nil
    end

    it 'assigns the seller to the WaitingSeller' do
      result = perform_operation(default_params)

      expect(waiting_seller.reload.seller).to eq(result['seller'])
    end

    it 'sets the "joined_at" timestamp' do
      time = 1.hour.ago

      Timecop.freeze(time) do
        perform_operation(default_params)
      end

      expect(waiting_seller.reload.joined_at.to_i).to eq(time.to_i)
    end
  end
end
