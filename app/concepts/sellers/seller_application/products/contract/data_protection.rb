module Sellers::SellerApplication::Products::Contract
  class DataProtection < Base
    property :encryption_transit_user_types, on: :product
    property :encryption_transit_user_other, on: :product
    property :encryption_transit_network_types, on: :product
    property :encryption_transit_network_other, on: :product
    property :encryption_rest_types, on: :product
    property :encryption_rest_other, on: :product
    property :encryption_keys_controller, on: :product

    validation :default, inherit: true do
      required(:product).schema do
        required(:encryption_transit_user_types).filled(any_checked?: true, one_of?: Product.encryption_transit_user_types.values)
        required(:encryption_transit_user_other).maybe(:str?)

        rule(encryption_transit_user_other: [:encryption_transit_user_types, :encryption_transit_user_other]) do |checkboxes, field|
          checkboxes.contains?('other').then(field.filled?)
        end

        required(:encryption_transit_network_types).filled(any_checked?: true, one_of?: Product.encryption_transit_network_types.values)
        required(:encryption_transit_network_other).maybe(:str?)

        rule(encryption_transit_network_other: [:encryption_transit_network_types, :encryption_transit_network_other]) do |checkboxes, field|
          checkboxes.contains?('other').then(field.filled?)
        end

        required(:encryption_rest_types).filled(any_checked?: true, one_of?: Product.encryption_rest_types.values)
        required(:encryption_rest_other).maybe(:str?)

        rule(encryption_rest_other: [:encryption_rest_types, :encryption_rest_other]) do |checkboxes, field|
          checkboxes.contains?('other').then(field.filled?)
        end

        required(:encryption_keys_controller).filled(in_list?: Product.encryption_keys_controller.values)
      end
    end
  end
end
