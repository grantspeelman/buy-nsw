class Sellers::Applications::Products::InfoForm < BaseForm
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
