class BuyerApplicationMailerPreview < ActionMailer::Preview
  def manager_approval_email
    application = FactoryBot.create(:awaiting_manager_approval_buyer_application)
    mail = BuyerApplicationMailer.with(application: application).manager_approval_email
    application.destroy
    mail
  end

  def application_approved_email
    application = FactoryBot.create(:approved_buyer_application)
    mail = BuyerApplicationMailer.with(application: application).application_approved_email
    application.destroy
    mail
  end

  def application_rejected_email
    application = FactoryBot.create(:rejected_buyer_application)
    mail = BuyerApplicationMailer.with(application: application).application_rejected_email
    application.destroy
    mail
  end
end
