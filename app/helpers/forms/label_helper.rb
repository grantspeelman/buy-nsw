module Forms::LabelHelper
  def service_description_text(key)
    I18n.translate("activerecord.help.sellers/applications/services_form.#{key}")
  end
end
