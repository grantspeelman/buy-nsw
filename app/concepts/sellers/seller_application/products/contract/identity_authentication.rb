module Sellers::SellerApplication::Products::Contract
  class IdentityAuthentication < Base
    property :name, on: :product

    property :authentication_required, on: :product
    property :authentication_types, on: :product
    property :authentication_other, on: :product

    validation :default, inherit: true do
      required(:product).schema do
        required(:authentication_required).filled(:bool?)

        required(:authentication_types).maybe(any_checked?: true, one_of?: Product.authentication_types.values)
        required(:authentication_other).maybe(:str?)

        rule(authentication_types: [:authentication_required, :authentication_types]) do |radio, field|
          radio.true?.then(field.filled?)
        end
        rule(authentication_other: [:authentication_required, :authentication_types, :authentication_other]) do |radio, checkboxes, field|
          (radio.true? & checkboxes.contains?('other')).then(field.filled?)
        end
      end
    end
  end
end
