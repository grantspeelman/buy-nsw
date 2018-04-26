module Sellers::SellerApplication::Products::Contract
  class Basics < Reform::Form
    include Concerns::Contracts::Composition
    include Concerns::Contracts::MultiStepForm
    include Concerns::Contracts::Status
    include Forms::ValidationHelper

    model :product

    property :name, on: :product
    property :summary, on: :product
    property :section, on: :product
    property :audiences, on: :product

    property :section_text, writeable: false, on: :product

    validation :default do
      required(:product).schema do
        required(:name).filled
        required(:summary).filled
      end
    end

  end
end
