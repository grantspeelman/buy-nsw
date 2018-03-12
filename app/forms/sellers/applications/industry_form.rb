class Sellers::Applications::IndustryForm < Sellers::Applications::BaseForm
  property :industry, on: :seller

  validation :default, inherit: true do
    required(:seller).schema do
      required(:industry).filled(:any_checked?)
    end
  end
end
