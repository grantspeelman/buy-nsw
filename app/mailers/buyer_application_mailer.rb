class BuyerApplicationMailer < ApplicationMailer

  def manager_approval_email
    @application = params[:application]

    mail(
      to: @application.manager_email,
      subject: "NSW Procurement Hub: Your approval required for #{@application.user.email}",
    )
  end

end
