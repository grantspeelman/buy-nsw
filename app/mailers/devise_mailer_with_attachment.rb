# Override devise mailer so that we can include inline image attachment
class DeviseMailerWithAttachment < Devise::Mailer
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  include ActionView::Helpers::AssetUrlHelper
  default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views

  before_action :add_image_attachment

  private

  def add_image_attachment
    attachments.inline['nsw-logo-80x85.png'] = File.read(File.join(Rails.root, "app", "assets", path_to_image("nsw-logo-80x85.png")))
  end
end
