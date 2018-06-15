class WaiterSellerMailerPreview < ActionMailer::Preview
  def invitation_email
    waiting_seller = WaitingSeller.create!(
      name: "Churchill-Smith Consultants",
      abn: "10123456987",
      contact_name: "Churchill Smith-Winston",
      contact_email: "test-2@test.buy.nsw.gov.au",
      invitation_token: "abc"
    )
    mail = WaitingSellerMailer.with(waiting_seller: waiting_seller).invitation_email
    waiting_seller.destroy
    mail
  end
end
