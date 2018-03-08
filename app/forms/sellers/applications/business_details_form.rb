class Sellers::Applications::BusinessDetailsForm < Sellers::Applications::BaseForm
  AddressPopulator = -> (options) {
    return NestedChildPopulator.call(options.merge(
      params: [:address, :suburb, :state, :postcode],
      model_klass: SellerAddress,
      context: self,
    ))
  }
  AddressPrepopulator = ->(_) {
    if self.addresses.size < 1
      self.addresses << SellerAddress.new(seller_id: seller_id)
    end
  }

  property :name,         on: :seller
  property :abn,          on: :seller
  property :summary,      on: :seller
  property :website_url,  on: :seller
  property :linkedin_url, on: :seller

  validation :default do
    required(:seller).schema do
      required(:name).filled
      required(:abn).filled
      required(:summary).filled
      required(:website_url).filled
    end
  end

  collection :addresses, on: :seller, prepopulator: AddressPrepopulator, populator: AddressPopulator do
    property :address
    property :suburb
    property :state
    property :postcode

    validation :default do
      required(:address).filled
      required(:suburb).filled
      required(:state).filled
      required(:postcode).filled
    end
  end

  def valid?
    super && addresses.map(&:valid?).any?
  end
end
