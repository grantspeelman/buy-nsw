class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('EMAIL_FROM_ADDRESS', 'noreply@dev.procurement-hub.nsw.gov.au')
  layout 'mailer'
end
