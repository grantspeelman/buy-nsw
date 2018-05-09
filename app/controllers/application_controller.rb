class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  force_ssl if: :ssl_configured?
  before_action :authenticate!

  class NotAuthorized < StandardError; end
  class NotFound < StandardError; end

  rescue_from NotAuthorized, with: :render_unauthorized
  rescue_from NotFound, with: :render_not_found
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

private
  def authenticate!
    return unless ENV['BASIC_USERNAME'].present? && ENV['BASIC_PASSWORD'].present?

    authenticate_or_request_with_http_basic do |username, password|
      username == ENV['BASIC_USERNAME'] && password == ENV['BASIC_PASSWORD']
    end
  end

  def authorize_buyer!
    unless current_user.buyer.present? && current_user.buyer.active?
      raise NotAuthorized
    end
  end

  def ssl_configured?
    ENV['FORCE_SSL'].present?
  end

  def render_not_found
    render file: Rails.root.join('public', '404.html'), status: 404, layout: nil
  end

  def render_unauthorized
    if current_user.present?
      flash.alert = 'You are not permitted to access this page.'
      redirect_to root_path
    else
      redirect_to new_user_session_path
    end
  end
end
