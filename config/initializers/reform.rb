# Set Reform to use dry-validation instead of ActiveModel validations
#
Rails.application.config.reform.validations = :dry

Dry::Validation::Schema::Form.configure do |config|
  config.messages = :i18n
end

class Trailblazer::Rails::Form < SimpleDelegator
  def to_model
    self.respond_to?(:base_form) ? self.base_form : self
  end
end
