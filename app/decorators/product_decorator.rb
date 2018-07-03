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

  def display_additional_terms?
    terms.document.present? && terms.scan_status == 'clean'
  end

  def pricing_currency
    super == 'other' ? pricing_currency_other : super
  end

  def pricing_min_with_currency
    parse_money(pricing_min)
  end

  def pricing_max_with_currency
    parse_money(pricing_max)
  end

  def formatted_pricing_min
    pricing_min_with_currency&.format(with_currency: true)
  end

  def formatted_pricing_max
    pricing_max_with_currency&.format(with_currency: true)
  end

  def details
    ProductDetails.new(__getobj__).details
  end

  def all_details
    ProductDetails.new(__getobj__, include_all: true).details
  end

private
  def parse_money(amount)
    return nil if pricing_currency.blank?
    begin
      Money.new(amount, pricing_currency)
    rescue Money::Currency::UnknownCurrency
      nil
    end
  end

end
