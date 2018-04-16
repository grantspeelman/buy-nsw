class BuyerApplicationMailerPreview < ActionMailer::Preview
  def manager_approval_email
    BuyerApplicationMailer.
      with(application: BuyerApplication.awaiting_manager_approval.first).
      manager_approval_email
  end

  def application_approved_email
    # TODO: Really should have some seed data that has an approved application already there
    application = BuyerApplication.approved.first
    BuyerApplicationMailer.with(application: application).application_approved_email
  end

  def application_rejected_email
    # TODO: Really should have some seed data that has a rejected application already there
    application = BuyerApplication.rejected.first
    BuyerApplicationMailer.with(application: application).application_rejected_email
  end
end
