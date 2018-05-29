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

  # Super crude way of doing a feature flag
  def feature_flag_hide_buyer_pathway
    ENV['FEATURE_FLAG_HIDE_BUYER_PATHWAY'].present?
  end
end
