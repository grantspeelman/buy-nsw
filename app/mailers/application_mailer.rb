class ApplicationMailer < ActionMailer::Base
  include ActionView::Helpers::AssetUrlHelper
  default from: ENV.fetch('EMAIL_FROM_ADDRESS', 'noreply@dev.procurement-hub.nsw.gov.au')
  layout 'mailer'
  before_action :add_image_attachment

  private

  def add_image_attachment
    attachments.inline['nsw-logo-80x85.png'] = File.read(File.join(Rails.root, "app", "assets", path_to_image("nsw-logo-80x85.png")))
  end
end
