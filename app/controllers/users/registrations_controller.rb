class Users::RegistrationsController < Devise::RegistrationsController
  before_action :assert_valid_user_type!, only: [:new, :create]
  prepend_before_action :_redirect_to_onboarding_when_signed_in, only: :new

private
  def user_type
    params[:type] if ['buyer', 'seller'].include?(params[:type])
  end
  helper_method :user_type

  def assert_valid_user_type!
    raise NotFound unless user_type.present?
  end

protected

  def _redirect_to_onboarding_when_signed_in
    if user_signed_in?
      redirect_to new_sellers_application_path if user_type == 'seller'
      redirect_to new_buyers_application_path if user_type == 'buyer'
    end
  end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    registration_confirm_path(user_type, email: resource.email)
  end

  def build_resource(params = {})
    super(params)
    self.resource.roles = [ user_type ]
  end
end
