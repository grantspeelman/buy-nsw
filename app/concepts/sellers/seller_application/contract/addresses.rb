module Sellers::SellerApplication::Contract
  class Addresses < Base
    include Concerns::Contracts::Populators

    AddressPopulator = -> (options) {
      return NestedChildPopulator.call(options.merge(
        params: [:address, :suburb, :state, :postcode],
        model_klass: SellerAddress,
        context: self,
        foreign_key: :seller_id,
      ))
    }
    AddressPrepopulator = ->(_) {
      if self.addresses.size < 1
        self.addresses << SellerAddress.new(seller_id: seller_id)
      end
    }

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

    validation :default do
      required(:seller).schema do
        optional(:addresses).each do
          schema do
            required(:address).filled
            required(:suburb).filled
            required(:state).filled
            required(:postcode).filled
          end
        end

        optional(:addresses_attributes).each do
          schema do
            required(:address).filled
            required(:suburb).filled
            required(:state).filled
            required(:postcode).filled
          end
        end

        rule(addresses_present?: [:addresses]) do |addresses|
          addresses.array? > addresses.min_size?(1)
        end
      end
    end
  end
end
