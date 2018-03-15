class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  force_ssl if: :ssl_configured?
  before_action :authenticate!

private
  def authenticate!
    return unless ENV['BASIC_USERNAME'].present? && ENV['BASIC_PASSWORD'].present?

    authenticate_or_request_with_http_basic do |username, password|
      username == ENV['BASIC_USERNAME'] && password == ENV['BASIC_PASSWORD']
    end
  end

  def ssl_configured?
    ENV['FORCE_SSL'].present?
  end

  def error_404
    render file: Rails.root.join('public', '404.html'), status: 404
  end
end
