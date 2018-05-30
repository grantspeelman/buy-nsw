module Sellers::SellerApplication::Contract
  class Services < Base
    property :offers_cloud, virtual: true
    property :services, on: :seller
    property :govdc, on: :seller

    def offers_cloud
      self.services.any? ? self.services.include?('cloud-services') : nil
    end

    def deserialize!(document)
      hash = super(document)

      if hash[:services]
        if hash[:offers_cloud] == 'true'
          hash[:services] << 'cloud-services'
        else
          services.delete('cloud-services')
        end

        if hash[:govdc] == 'true'
          hash[:services] << 'infrastructure'
        end
      end

      hash
    end

    validation :default, inherit: true do
      configure do
        def offers_cloud?(list)
          list.include?('cloud-services')
        end
      end

      required(:seller).schema do
        required(:services).maybe(one_of?: Seller.services.values)
        required(:govdc).filled(:bool?)

        rule(services: [:offers_cloud, :services]) do |offers_cloud, services|
          offers_cloud.true?.then(services.filled?)
        end

        rule(eligible_seller: [:services, :govdc]) do |services, govdc|
          services.offers_cloud? | govdc.true?
        end
      end
    end
  end
end
