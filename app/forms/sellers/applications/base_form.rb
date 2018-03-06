require 'ostruct'

class Sellers::Applications::BaseForm < Reform::Form
  include Composition
  model :application

  def self.human_attribute_name(attribute_key_name, options = {})
    I18n.t("activemodel.attributes.#{self.to_s.underscore}.#{attribute_key_name}", options)
  end

  def seller_id
    self.model[:seller].id
  end

  def upload_for(key)
    self.model[:seller].public_send(key)
  end

  # The following bit of hackery bodges the way that the model name is returned
  # back from ActiveModel. It's important to set this correctly otherwise the
  # I18n translation paths will always be the same for all forms.
  #
  class << self
    def model_name
      AdaptiveModelName.new(super)
    end
  end

  class AdaptiveModelName < SimpleDelegator
    def name
      __getobj__.instance_variable_get(:@klass).name
    end
  end
end
