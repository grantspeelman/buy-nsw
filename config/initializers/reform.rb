require 'reform'

# Set Reform to use dry-validation instead of ActiveModel validations
#
Rails.application.config.reform.validations = :dry

Dry::Validation::Schema::Form.configure do |config|
  config.messages = :i18n
end

class Reform::Contract::Errors
  def full_messages_for(key)
    messages[key]
  end
end
