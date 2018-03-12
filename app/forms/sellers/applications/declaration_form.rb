class Sellers::Applications::DeclarationForm < Sellers::Applications::BaseForm
  property :agree, on: :seller

  validation :default do
    required(:seller).schema do
      required(:agree).filled(:bool?, :true?)
    end
  end
end
