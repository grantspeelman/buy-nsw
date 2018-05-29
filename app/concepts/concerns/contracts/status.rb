module Concerns::Contracts::Status
  extend ActiveSupport::Concern

  def started?(&block)
    out = schema.keys.map {|key|
      value = send(key)

      if value.is_a?(Array)
        value.any? {|item|
          item.respond_to?(:id) ? item.id.present? : item.present?
        }
      elsif value.is_a?(DocumentUploader)
        value.file.present?
      else
        if block_given?
          yield(key, value)
        else
          value.present? || value == false
        end
      end
    }.compact

    out.any?
  end
end
