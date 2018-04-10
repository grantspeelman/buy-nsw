module Concerns::Contracts::MultiStepForm
  extend ActiveSupport::Concern

  class_methods do
    def human_attribute_name(attribute_key_name, options = {})
      I18n.t("activemodel.attributes.#{self.to_s.underscore}.#{attribute_key_name}", options)
    end

    def model_name
      ActiveModel::Name.new(self)
    end
  end
end
