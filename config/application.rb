require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ProcurementHub
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.action_mailer.delivery_method = :smtp
    config.action_mailer.default_url_options = {
      host: ENV['EMAIL_URL_HOST'],
      port: ENV.fetch('EMAIL_URL_PORT', 80),
    }
    config.action_mailer.smtp_settings = {
      user_name: ENV['SMTP_USERNAME'],
      password: ENV['SMTP_PASSWORD'],
      domain: ENV['SMTP_DOMAIN'],
      address: ENV['SMTP_HOST'],
      port: ENV.fetch('SMTP_PORT', '587'),
      authentication: :plain,
      enable_starttls_auto: true,
    }

    config.action_mailer.deliver_later_queue_name = ENV['MAILER_QUEUE_NAME']

    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.yml')]
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '**', '*.yml')]

    config.to_prepare do
      Devise::Mailer.layout 'mailer'
    end

    config.exceptions_app = self.routes

    # Doing this here so it's added after premailer
    config.after_initialize do
      unless Rails.env.test?
        ActionMailer::Base.register_interceptor(StyleTagRemoverInterceptor)
      end
    end
  end
end
