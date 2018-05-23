class WaitingSellerMailer < ApplicationMailer
  default to: -> { params[:waiting_seller].contact_email }

  def invitation_email
    @waiting_seller = params[:waiting_seller]
    mail(subject: "buy.nsw: Your invitation to sign up now")
  end
end
