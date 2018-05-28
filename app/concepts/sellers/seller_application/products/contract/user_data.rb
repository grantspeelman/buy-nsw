module Sellers::SellerApplication::Products::Contract
  class UserData < Base
    property :data_import_formats, on: :product
    property :data_import_formats_other, on: :product
    property :data_export_formats, on: :product
    property :data_export_formats_other, on: :product

    property :data_access_restrictions, on: :product
    property :data_access_restrictions_details, on: :product
    property :audit_information, on: :product
    property :audit_storage_period, on: :product
    property :log_storage_period, on: :product

    validation :default, inherit: true do
      required(:product).schema do
        required(:data_import_formats).maybe(one_of?: Product.data_import_formats.values)
        required(:data_import_formats_other).maybe(:str?)

        rule(data_import_formats_other: [:data_import_formats, :data_import_formats_other]) do |checkboxes, field|
          checkboxes.contains?('other').then(field.filled?)
        end

        required(:data_export_formats).maybe(one_of?: Product.data_export_formats.values)
        required(:data_export_formats_other).maybe(:str?)

        rule(data_export_formats_other: [:data_export_formats, :data_export_formats_other]) do |checkboxes, field|
          checkboxes.contains?('other').then(field.filled?)
        end

        required(:data_access_restrictions).filled(:bool?)
        required(:data_access_restrictions_details).maybe(:str?)

        rule(data_access_restrictions_details: [:data_access_restrictions, :data_access_restrictions_details]) do |radio, field|
          radio.true?.then(field.filled?)
        end

        required(:audit_information).filled(:bool?)
        required(:audit_storage_period).filled(:str?)
        required(:log_storage_period).filled(:str?)
      end
    end
  end
end
