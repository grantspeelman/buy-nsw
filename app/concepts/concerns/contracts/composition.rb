module Concerns::Contracts::Composition
  extend ActiveSupport::Concern

  included do
    include Reform::Form::Composition
  end

  def errors
    new_errors = Reform::Contract::Errors.new

    new_messages = super.messages.select {|key, value|
      self.model.keys.include?(key) && value.first&.is_a?(Array)
    }

    new_messages.each do |model, errors|
      errors.each do |field, msgs|
        # Support accessing the keys as both strings and symbols, as the form
        # builder seems to require both for all fields to work.
        #
        new_errors.messages[field.to_s] = msgs
        new_errors.messages[field] = msgs
      end
    end

    new_messages.any? ? new_errors : super
  end
end
