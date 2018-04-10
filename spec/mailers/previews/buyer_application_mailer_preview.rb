class BuyerApplicationMailerPreview < ActionMailer::Preview
  def manager_approval_email
    BuyerApplicationMailer.
      with(application: BuyerApplication.awaiting_manager_approval.first).
      manager_approval_email
  end
end
