class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('EMAIL_FROM_ADDRESS')
  layout 'mailer'
end
