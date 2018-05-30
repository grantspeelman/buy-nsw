module Forms::LabelHelper
  def service_description_text(key)
    I18n.translate("activerecord.help.sellers/seller_application/contract/services.#{key}")
  end

  def seller_application_field_label(key)
    I18n.t "activemodel.attributes.sellers.seller_application.contract.#{key}"
  end
end
