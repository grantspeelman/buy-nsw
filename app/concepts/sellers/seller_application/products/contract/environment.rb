module Sellers::SellerApplication::Products::Contract
  class Environment < Base
    property :deployment_model, on: :product

    property :addon_extension_type, on: :product
    property :addon_extension_details, on: :product

    property :api, on: :product
    property :api_capabilities, on: :product
    property :api_automation, on: :product
    property :api_documentation, on: :product
    property :api_sandbox, on: :product

    property :government_network_type, on: :product
    property :government_network_other, on: :product

    property :web_interface, on: :product
    property :web_interface_details, on: :product
    property :supported_browsers, on: :product

    property :installed_application, on: :product
    property :supported_os, on: :product
    property :supported_os_other, on: :product

    property :mobile_devices, on: :product
    property :mobile_desktop_differences, on: :product

    property :accessibility_type, on: :product
    property :accessibility_exclusions, on: :product

    property :scaling_type, on: :product

    validation :default, inherit: true do
      required(:product).schema do
        required(:deployment_model).filled(in_list?: Product.deployment_model.values)

        required(:addon_extension_type).filled(in_list?: Product.addon_extension_type.values)
        required(:addon_extension_details).maybe(:str?)

        rule(addon_extension_details: [:addon_extension_type, :addon_extension_details]) do |radio, field|
          ( radio.eql?('yes') | radio.eql?('yes-and-standalone') ).then(field.filled?)
        end

        required(:api).filled(:bool?)
        required(:api_capabilities).maybe(:str?)
        required(:api_automation).maybe(:str?)
        required(:api_documentation).maybe(:bool?)
        required(:api_sandbox).maybe(:bool?)

        rule(api_capabilities: [:api, :api_capabilities]) do |radio, field|
          radio.true?.then(field.filled?)
        end
        rule(api_automation: [:api, :api_automation]) do |radio, field|
          radio.true?.then(field.filled?)
        end
        rule(api_documentation: [:api, :api_documentation]) do |radio, field|
          radio.true?.then(field.filled?)
        end
        rule(api_sandbox: [:api, :api_sandbox]) do |radio, field|
          radio.true?.then(field.filled?)
        end

        required(:government_network_type).filled(one_of?: Product.government_network_type.values)
        required(:government_network_other).maybe(:str?)

        rule(government_network_other: [:government_network_type, :government_network_other]) do |checkboxes, field|
          checkboxes.contains?('other').then(field.filled?)
        end

        required(:web_interface).filled(:bool?)
        required(:web_interface_details).maybe(:str?)
        optional(:supported_browsers).maybe(one_of?: Product.supported_browsers.values)

        rule(web_interface_details: [:web_interface, :web_interface_details]) do |radio, field|
          radio.true?.then(field.filled?.any_checked?)
        end
        rule(supported_browsers: [:web_interface, :supported_browsers]) do |radio, field|
          radio.true?.then(field.filled?)
        end

        required(:installed_application).filled(:bool?)
        optional(:supported_os).maybe(one_of?: Product.supported_os.values)
        required(:supported_os_other).maybe(:str?)

        rule(supported_os: [:installed_application, :supported_os]) do |radio, field|
          radio.true?.then(field.filled?.any_checked?)
        end
        rule(supported_os_other: [:installed_application, :supported_os, :supported_os_other]) do |radio, checkboxes, field|
          (radio.true? & checkboxes.contains?('other')).then(field.filled?)
        end

        required(:mobile_devices).filled(:bool?)
        required(:mobile_desktop_differences).maybe(:str?)

        rule(mobile_desktop_differences: [:mobile_devices, :mobile_desktop_differences]) do |radio, field|
          radio.true?.then(field.filled?)
        end

        required(:accessibility_type).filled(in_list?: Product.accessibility_type.values)
        required(:accessibility_exclusions).maybe(:str?)

        rule(accessibility_exclusions: [:accessibility_type, :accessibility_exclusions]) do |radio, field|
          radio.eql?('exclusions').then(field.filled?)
        end

        required(:scaling_type).filled(in_list?: Product.scaling_type.values)
      end
    end
  end
end
