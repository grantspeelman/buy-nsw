class Sellers::Applications::ServicesForm < Sellers::Applications::BaseForm
  property :services, on: :seller

  validation :default, inherit: true do
    required(:seller).schema do
      required(:services).filled(:any_checked?)
    end
  end
end
