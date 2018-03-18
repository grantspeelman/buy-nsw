class Sellers::Applications::IndustryForm < Sellers::Applications::BaseForm
  property :industry, on: :seller

  validation :default, inherit: true do
    required(:seller).schema do
      required(:industry).value(any_checked?: true, one_of?: Seller.industry.values)
    end
  end
end
