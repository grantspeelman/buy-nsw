class SellerApplicationMailer < ApplicationMailer
  helper :application

  # TODO: Probably want the person's name in there too
  default to: -> { params[:application].owners.map(&:email) }

  def application_approved_email
    @application = params[:application]
    mail(subject: "Your application has been successful")
  end

  def application_rejected_email
    @application = params[:application]
    mail(subject: "Sorry, your application has not been approved")
  end

  def application_return_to_applicant_email
    @application = params[:application]
    mail(subject: "Your application needs some changes before it can be approved")
  end
end
