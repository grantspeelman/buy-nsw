class BaseForm < Reform::Form
  def started?
    schema.keys.map {|key|
      value = send(key)

      if value.is_a?(Array)
        value.first&.id.present?
      else
        value.present? || value == false
      end
    }.compact.any?
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
