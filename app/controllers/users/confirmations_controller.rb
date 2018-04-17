class Users::ConfirmationsController < Devise::ConfirmationsController

protected

  def after_confirmation_path_for(resource_name, resource)
    sign_in(resource)

    if resource.is_seller?
      new_sellers_application_path
    else
      new_buyers_application_path
    end
  end

end
