class Sellers::Applications::MethodsForm < Sellers::Applications::BaseForm
  property :tools,         on: :seller
  property :methodologies, on: :seller
  property :technologies,  on: :seller
end
