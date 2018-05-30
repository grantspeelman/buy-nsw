module InvitationHelper
  def owner_name(application)
    if application.seller.name.present?
      application.seller.name
    else
      application.owners.first.email
    end
  end
end
