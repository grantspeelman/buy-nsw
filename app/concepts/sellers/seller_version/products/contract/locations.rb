module Sellers::SellerVersion::Products::Contract
  class Locations < Base
    property :data_location_control, on: :product

    property :data_location, on: :product
    property :data_location_other, on: :product
    property :data_location_unknown_reason, on: :product

    property :own_data_centre, on: :product
    property :own_data_centre_details, on: :product

    property :third_party_involved, on: :product
    property :third_party_involved_details, on: :product

    validation :default, inherit: true do
      required(:product).schema do
        required(:data_location_control).filled(:bool?)

        required(:data_location).filled(in_list?: Product.data_location.values)
        required(:data_location_other).maybe(:str?)
        required(:data_location_unknown_reason).maybe(:str?)

        rule(data_location_other: [:data_location, :data_location_other]) do |radio, field|
          radio.eql?('other-known').then(field.filled?)
        end
        rule(data_location_unknown_reason: [:data_location, :data_location_unknown_reason]) do |radio, field|
          radio.eql?('dont-know').then(field.filled?)
        end

        required(:own_data_centre).filled(:bool?)
        required(:own_data_centre_details).maybe(:str?)

        rule(own_data_centre_details: [:own_data_centre, :own_data_centre_details]) do |radio, field|
          radio.true?.then(field.filled?)
        end

        required(:third_party_involved).filled(:bool?)
        required(:third_party_involved_details).maybe(:str?)

        rule(third_party_involved_details: [:third_party_involved, :third_party_involved_details]) do |radio, field|
          radio.true?.then(field.filled?)
        end
      end
    end
  end
end
