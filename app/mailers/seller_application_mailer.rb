class SellerApplicationMailer < ApplicationMailer

  def application_approved_email
    @application = params[:application]

    mail(
      # TODO: Probably want the person's name in there too
      to: @application.owner.email,
      subject: "Congratulations, your application has been approved"
    )
  end

end
