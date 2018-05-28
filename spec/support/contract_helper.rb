module ContractHelper
  extend ActiveSupport::Concern

  class_methods do
    def assert_invalidity_of_blank_field(field)
      it "is invalid when '#{field}' is blank" do
        unless self.respond_to?(:subject)
          raise("You need to define `subject` in your spec file to use this helper")
        end

        form = subject
        form.validate(atts.merge(field => nil))

        expect(form).to_not be_valid
        expect(form.errors[field]).to be_present
      end
    end
  end
end

RSpec.configure do |config|
  config.include ContractHelper
end
