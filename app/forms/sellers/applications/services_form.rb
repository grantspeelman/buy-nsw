class Sellers::Applications::ServicesForm < Sellers::Applications::BaseForm
  property :services, on: :seller

  validation :default, inherit: true do
    required(:seller).schema do
      required(:services).value(any_checked?: true, one_of?: Seller.services.values)
    end
  end
end
