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

  def details
    ProductDetails.new(__getobj__).details
  end

  def all_details
    ProductDetails.new(__getobj__, include_all: true).details
  end

end
