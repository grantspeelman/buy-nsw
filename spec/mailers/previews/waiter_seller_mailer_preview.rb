class WaiterSellerMailerPreview < ActionMailer::Preview
  def invitation_email
    waiting_seller = FactoryBot.create(:invited_waiting_seller)
    mail = WaitingSellerMailer.with(waiting_seller: waiting_seller).invitation_email
    waiting_seller.destroy
    mail
  end
end
