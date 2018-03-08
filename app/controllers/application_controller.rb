class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

private
  def error_404
    render file: Rails.root.join('public', '404.html'), status: 404
  end
end
