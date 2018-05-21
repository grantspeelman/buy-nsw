module ApplicationHelper
  include Forms::DateHelper
  include Forms::DocumentHelper
  include Forms::ErrorHelper
  include Forms::LabelHelper

  def deployment_env
    if Rails.env.development?
      'development'
    else
      ENV['DEPLOYMENT_ENVIRONMENT']
    end
  end

end
