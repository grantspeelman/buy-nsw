class Sellers::Applications::Products::InfoForm < Reform::Form
  model :product

  property :name

  validation :default do
    required(:name).filled(:str?)
  end
end
