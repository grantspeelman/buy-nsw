module Sellers::SellerApplication::Products::Contract
  class UserData < Base
    property :data_import_formats, on: :product
    property :data_import_formats_other, on: :product
    property :data_export_formats, on: :product
    property :data_export_formats_other, on: :product
    property :data_access, on: :product

    property :audit_access_type, on: :product
    property :audit_storage_period, on: :product
    property :log_storage_period, on: :product

    property :data_location, on: :product
    property :data_location_other, on: :product
    property :data_storage_control_australia, on: :product
    property :third_party_infrastructure, on: :product
    property :third_party_infrastructure_details, on: :product

    property :backup_capability, on: :product
    property :disaster_recovery_type, on: :product
    property :backup_scheduling_type, on: :product
    property :backup_recovery_type, on: :product

    property :encryption_transit_user_types, on: :product
    property :encryption_transit_user_other, on: :product
    property :encryption_transit_network_types, on: :product
    property :encryption_transit_network_other, on: :product
    property :encryption_rest_types, on: :product
    property :encryption_rest_other, on: :product

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

        required(:data_access).filled(in_list?: Product.data_access.values)

        required(:audit_access_type).filled(in_list?: Product.audit_access_type.values)
        required(:audit_storage_period).filled(in_list?: Product.audit_storage_period.values)
        required(:log_storage_period).filled(in_list?: Product.log_storage_period.values)

        required(:data_location).filled(in_list?: Product.data_location.values)
        required(:data_location_other).maybe(:str?)

        rule(data_location_other: [:data_location, :data_location_other]) do |radio, field|
          radio.eql?('other-known').then(field.filled?)
        end

        required(:data_storage_control_australia).filled(:bool?)
        required(:third_party_infrastructure).filled(:bool?)
        required(:third_party_infrastructure_details).maybe(:str?)

        rule(third_party_infrastructure_details: [:third_party_infrastructure, :third_party_infrastructure_details]) do |radio, field|
          radio.true?.then(field.filled?)
        end

        required(:backup_capability).filled(:str?)
        required(:disaster_recovery_type).filled(in_list?: Product.disaster_recovery_type.values)
        required(:backup_scheduling_type).filled(in_list?: Product.backup_scheduling_type.values)
        required(:backup_recovery_type).filled(in_list?: Product.backup_recovery_type.values)

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
      end
    end
  end
end
