class Users::RegistrationsController < Devise::RegistrationsController
  before_action :assert_valid_user_type!

private
  def user_type
    params[:type] if ['buyer', 'seller'].include?(params[:type])
  end
  helper_method :user_type

  def assert_valid_user_type!
    raise NotFound unless user_type.present?
  end

protected

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    registration_confirm_path(user_type, email: resource.email)
  end

  def build_resource(params = {})
    super(params)
    self.resource.roles = [ user_type ]
  end
end
