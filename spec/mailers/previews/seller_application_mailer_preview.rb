class SellerApplicationMailerPreview < ActionMailer::Preview
  def application_approved_email
    # TODO: Really should have some seed data that has an approved application already there
    application = SellerApplication.approved.first
    SellerApplicationMailer.with(application: application).application_approved_email
  end

  def application_rejected_email
    # TODO: Really should have some seed data that has a rejected application already there
    application = SellerApplication.rejected.first
    SellerApplicationMailer.with(application: application).application_rejected_email
  end
end
