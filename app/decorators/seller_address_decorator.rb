class SellerAddressDecorator < BaseDecorator

  def country
    ISO3166::Country.translations[super]
  end

end
