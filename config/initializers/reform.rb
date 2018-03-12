# Set Reform to use dry-validation instead of ActiveModel validations
#
Rails.application.config.reform.validations = :dry

Dry::Validation::Schema::Form.configure do |config|
  config.messages = :i18n
end
