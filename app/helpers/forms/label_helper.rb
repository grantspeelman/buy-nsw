module Forms::LabelHelper
  def service_description_text(key)
    I18n.translate(key, scope: [:sellers, :applications, :steps, :services, :descriptions])
  end
end
