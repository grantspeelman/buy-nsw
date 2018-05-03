class BuyerApplicationMailer < ApplicationMailer

  def manager_approval_email
    @application = params[:application]

    mail(
      to: @application.manager_email,
      subject: "buy.nsw: Your approval required for #{@application.user.email}",
    )
  end

  def application_approved_email
    @application = params[:application]

    mail(
      to: @application.user.email,
      subject: "buy.nsw: Your application has been approved",
    )
  end

  def application_rejected_email
    @application = params[:application]

    mail(
      to: @application.user.email,
      subject: "buy.nsw: Your application has been rejected",
    )
  end
end
