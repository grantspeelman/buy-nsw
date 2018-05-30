class SellerInvitationMailer < ApplicationMailer
  add_template_helper(Sellers::InvitationHelper)

  default to: -> { params[:user].email }

  def seller_invitation_email
    @application = params[:application]
    @user = params[:user]
    mail(subject: "You've been invited to work on a seller application: #{@application.seller.name}")
  end
end
