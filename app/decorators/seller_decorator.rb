class SellerDecorator < BaseDecorator

  def agreed_by_email
    agreed_by.email if agreed_by.present?
  end

end
