class Sellers::Applications::LegalsController < Sellers::Applications::QuestionGroupController
  layout '../sellers/applications/legals/_layout'

  before_action :verify_authorised_representative

private
  def verify_authorised_representative
    unless application.seller.representative_email.present? && current_user.email == application.seller.representative_email
      flash.alert = I18n.t('sellers.applications.messages.authorised_representative_only')
      redirect_to sellers_application_path(application)
    end
  end

  def operation_class
    Sellers::SellerApplication::Legals::Update
  end

  def operation_present_class
    Sellers::SellerApplication::Legals::Update::Present
  end
end
