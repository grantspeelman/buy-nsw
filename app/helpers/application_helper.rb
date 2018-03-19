module ApplicationHelper

  def deployment_env
    if Rails.env.development?
      'development'
    else
      ENV['DEPLOYMENT_ENVIRONMENT']
    end
  end

end
