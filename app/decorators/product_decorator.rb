class ProductDecorator < BaseDecorator

  def is_reselling?
    reseller_type && reseller_type != 'own-product'
  end

  def contact_name
    custom_contact? ? super : seller.contact_name
  end

  def contact_email
    custom_contact? ? super : seller.contact_email
  end

  def contact_phone
    custom_contact? ? super : seller.contact_phone
  end

  def pricing_variables_other?
    pricing_variables.include?('other')
  end

  def details
    @details ||= ProductDetails.new(self).details
  end

end
