class Sellers::WaitingSeller::Accept < Trailblazer::Operation
  class Present < Trailblazer::Operation
    step :model!
    step Contract::Build( constant: Sellers::WaitingSeller::Contract::Accept )
    success :setup_errors
    step :check_user_does_not_exist!
    step :check_seller_does_not_exist!, fail_fast: true
    failure :check_seller_does_not_exist!, fail_fast: true

    def model!(options, params:, **)
      options['model'] = WaitingSeller.invited.find_by!(invitation_token: params[:id])
    end

    def setup_errors(options, **)
      options['errors'] = []
    end

    def check_user_does_not_exist!(options, model:, **)
      if User.where(email: model.contact_email).any?
        options['errors'] << 'user_exists'
        return false
      end

      true
    end

    def check_seller_does_not_exist!(options, model:, **)
      if Seller.where(abn: model.abn).any?
        options['errors'] << 'seller_exists'
        return false
      end

      true
    end
  end

  step Nested(Present)
  step Contract::Validate( key: :invitation ), fail_fast: true

  step :create_user!
  failure :include_devise_errors!, fail_fast: true
  step :create_seller!
  step :create_seller_address!
  step :create_version!
  step :log_event!
  step :update_seller_assignment!
  step :update_invitation_state!

  def create_user!(options, model:, **)
    form = options['contract.default']

    options['user'] = User.new(
      email: model.contact_email,
      password: form.password,
      password_confirmation: form.password_confirmation,
      roles: ['seller'],
      confirmed_at: Time.now,
    )
    options['user'].valid? && options['user'].save
  end

  def create_seller!(options, model:, **)
    options['seller'] = Seller.new(
      name: model.name,
      abn: model.abn,
      contact_name: model.contact_name,
      contact_email: model.contact_email,
      website_url: model.website_url,
    )
    options['seller'].save!
  end

  def create_seller_address!(options, model:, **)
    options['seller_address'] = options['seller'].addresses.new(
      address: model.address,
      suburb: model.suburb,
      state: model.state,
      postcode: model.postcode,
      country: model.country,
    )
    options['seller_address'].save!
  end

  def create_version!(options, model:, **)
    options['application'] = options['seller'].versions.new(
      started_at: Time.now,
      name: model.name,
      abn: model.abn,
      contact_name: model.contact_name,
      contact_email: model.contact_email,
      website_url: model.website_url,
    )
    options['application'].save!
  end

  def log_event!(options, **)
    Event::StartedApplication.create(
      user: options['user'],
      eventable: options['application']
    )
  end

  def update_seller_assignment!(options, **)
    options['user'].update_attribute(:seller, options['seller'])
  end

  def update_invitation_state!(options, model:, **)
    model.seller = options['seller']
    model.invitation_token = nil
    model.joined_at = Time.now
    model.mark_as_joined

    model.save!
  end

  def include_devise_errors!(options, **)
    return if options['user'].blank?

    unless options['user'].valid?
      options['user'].errors.each do |key, message|
        options['contract.default'].errors.add(key, message)
      end
    end
  end
end
