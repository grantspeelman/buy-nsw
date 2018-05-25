module Forms::LabelHelper
  def service_description_text(key)
    I18n.translate("activerecord.help.sellers/seller_application/contract/services.#{key}")
  end

  def current_step_class(operation, step)
    operation['result.step'] == step ? 'current' : ''
  end
end
