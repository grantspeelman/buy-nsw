module Ops::WaitingSeller::Contract
  class Invite < Reform::Form
    include Forms::ValidationHelper

    def initialize(_ = nil)
      # There's no model for this form, but the superclass expects an argument
      #
      super(OpenStruct.new(ids: nil))
    end

    property :ids

    validation :default, inherit: true do
      required(:ids).each(:int?)
    end
  end
end
