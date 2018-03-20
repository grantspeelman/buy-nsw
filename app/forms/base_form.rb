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
end
