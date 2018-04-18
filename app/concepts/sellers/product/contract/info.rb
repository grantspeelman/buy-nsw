module Sellers::Product::Contract
  class Info < Reform::Form
    include Forms::ValidationHelper

    model :product

    property :name
    property :summary
    property :section
    property :audiences

    property :section_text, writeable: false

    validation :default do
      required(:name).filled
      required(:summary).filled
    end

  end
end
