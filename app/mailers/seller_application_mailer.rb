class SellerApplicationMailer < ApplicationMailer
  # TODO: Probably want the person's name in there too
  default to: -> { params[:application].owner.email }

  def application_approved_email
    @application = params[:application]

    mail(
      subject: "Congratulations, your application has been approved"
    )
  end

  def application_rejected_email
    @application = params[:application]

    mail(
      subject: "Sorry, your application has not been approved"
    )
  end
end
