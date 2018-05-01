module Concerns::Contracts::Status
  extend ActiveSupport::Concern

  def started?
    schema.keys.map {|key|
      value = send(key)

      if value.is_a?(Array)
        value.first&.id.present?
      else
        value.present?
      end
    }.compact.any?
  end
end
