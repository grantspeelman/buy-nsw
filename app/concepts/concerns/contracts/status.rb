module Concerns::Contracts::Status
  extend ActiveSupport::Concern

  def started?
    schema.keys.map {|key|
      value = send(key)

      if value.is_a?(Array)
        value.any? {|item|
          item.respond_to?(:id) ? item.id.present? : item.present?
        }
      else
        value.present? || value == false
      end
    }.compact.any?
  end
end
