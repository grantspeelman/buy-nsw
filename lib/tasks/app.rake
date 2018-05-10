require 'csv'
require 'factory_bot'

include FactoryBot::Syntax::Methods

namespace :app do
  namespace :sellers do
    namespace :create do

      desc "Create fake sellers data - WARNING deletes MOST data in the database"
      task fake: :environment do
        User.destroy_all
        SellerApplication.destroy_all
        Seller.destroy_all
        Product.destroy_all

        contact_name = Faker::Name.name
        representative_name = Faker::Name.name
        services = []
        services << 'cloud-services' if [false, true].sample
        services << 'software-development' if [false, true].sample
        services << 'software-licensing' if [false, true].sample
        services << 'end-user-computing' if [false, true].sample
        services << 'infrastructure' if [false, true].sample
        services << 'telecommunications' if [false, true].sample
        services << 'managed-services' if [false, true].sample
        services << 'advisory-consulting' if [false, true].sample
        services << 'ict-workforce' if [false, true].sample
        services << 'training-learning' if [false, true].sample

        industry = []
        industry << 'ict' if [false, true].sample
        industry << 'construction' if [false, true].sample
        industry << 'other' if [false, true].sample

        (1..20).each do |i|
          seller = create(
            :active_seller,
            name: Faker::Company.unique.name,
            abn: Faker::Company.unique.australian_business_number,
            summary: Faker::Company.catch_phrase,
            website_url: "https://#{Faker::Internet.domain_name}",
            linkedin_url: "http://linkedin.com/#{Faker::Internet.slug}",
            number_of_employees: Seller.number_of_employees.values.sample,
            start_up: [false, true].sample,
            sme: [false, true].sample,
            not_for_profit: [false, true].sample,
            regional: [false, true].sample,
            travel: [false, true].sample,
            disability: [false, true].sample,
            female_owned: [false, true].sample,
            indigenous: [false, true].sample,
            no_experience: [false, true].sample,
            local_government_experience: [false, true].sample,
            state_government_experience: [false, true].sample,
            federal_government_experience: [false, true].sample,
            international_government_experience: [false, true].sample,
            contact_name: contact_name,
            contact_email: Faker::Internet.email(contact_name),
            contact_phone: Faker::PhoneNumber.phone_number,
            representative_name: representative_name,
            representative_email: Faker::Internet.email(representative_name),
            representative_phone: Faker::PhoneNumber.phone_number,
            structural_changes: false,
            investigations: false,
            legal_proceedings: false,
            insurance_claims: false,
            conflicts_of_interest: false,
            other_circumstances: false,
            tools: Faker::Lorem.paragraph,
            methodologies: Faker::Lorem.paragraph,
            technologies: Faker::Lorem.paragraph,
            services: services,
            industry: industry,
            australian_owned: [false, true].sample,
            rural_remote: [false, true].sample,
            workers_compensation_exempt: false
          )
          # Each seller has between 1 and 5 products
          (1..Faker::Number.between(1,5)).each do |i|
            audiences = []
            Product.audiences.values.each do |value|
              audiences << value if [false, true].sample
            end
            pricing_min = Faker::Commerce.price

            create(
              :active_product,
              seller: seller,
              name: Faker::App.name,
              audiences: audiences,
              summary: Faker::Company.bs,
              section: Product.section.values.sample,
              reseller_type: Product.reseller_type.values.sample,
              pricing_min: pricing_min,
              pricing_max: pricing_min * Faker::Number.between(10, 1000),
              pricing_unit: ['per user per month', 'per server', 'per hour'].sample
            )

            # t.text "pricing_variables", default: [], array: true
            # t.text "pricing_variables_other"
            # t.string "pricing_calculator_url"
            # t.boolean "education_pricing"
            # t.text "education_pricing_eligibility"
            # t.text "education_pricing_differences"
            # t.text "onboarding_assistance"
            # t.text "offboarding_assistance"
            # t.string "deployment_model"
            # t.string "addon_extension_type"
            # t.text "addon_extension_details"
            # t.boolean "api"
            # t.text "api_capabilities"
            # t.text "api_automation"
            # t.boolean "api_documentation"
            # t.boolean "api_sandbox"
            # t.text "government_network_type", default: [], array: true
            # t.string "government_network_other"
            # t.boolean "web_interface"
            # t.text "web_interface_details"
            # t.text "supported_browsers", default: [], array: true
            # t.boolean "installed_application"
            # t.text "supported_os", default: [], array: true
            # t.text "supported_os_other"
            # t.boolean "mobile_devices"
            # t.text "mobile_desktop_differences"
            # t.string "accessibility_type"
            # t.text "accessibility_exclusions"
            # t.string "scaling_type"
            # t.text "guaranteed_availability"
            # t.text "support_options", default: [], array: true
            # t.text "support_hours"
            # t.text "support_levels"
            # t.text "data_import_formats", default: [], array: true
            # t.text "data_import_formats_other"
            # t.text "data_export_formats", default: [], array: true
            # t.text "data_export_formats_other"
            # t.string "data_access"
            # t.string "audit_access_type"
            # t.string "audit_storage_period"
            # t.string "log_storage_period"
            # t.string "data_location"
            # t.text "data_location_other"
            # t.boolean "data_storage_control_australia"
            # t.boolean "third_party_infrastructure"
            # t.text "third_party_infrastructure_details"
            # t.text "backup_capability"
            # t.string "disaster_recovery_type"
            # t.string "backup_scheduling_type"
            # t.string "backup_recovery_type"
            # t.text "encryption_transit_user_types", default: [], array: true
            # t.text "encryption_transit_user_other"
            # t.text "encryption_transit_network_types", default: [], array: true
            # t.text "encryption_transit_network_other"
            # t.text "encryption_rest_types", default: [], array: true
            # t.text "encryption_rest_other"
            # t.boolean "authentication_required"
            # t.text "authentication_types", default: [], array: true
            # t.text "authentication_other"
            # t.string "data_centre_security_standards"
            # t.boolean "iso_27001"
            # t.string "iso_27001_accreditor"
            # t.date "iso_27001_date"
            # t.text "iso_27001_exclusions"
            # t.boolean "iso_27017"
            # t.string "iso_27017_accreditor"
            # t.date "iso_27017_date"
            # t.text "iso_27017_exclusions"
            # t.boolean "iso_27018"
            # t.string "iso_27018_accreditor"
            # t.date "iso_27018_date"
            # t.text "iso_27018_exclusions"
            # t.boolean "csa_star"
            # t.string "csa_star_accreditor"
            # t.date "csa_star_date"
            # t.string "csa_star_level"
            # t.text "csa_star_exclusions"
            # t.boolean "pci_dss"
            # t.string "pci_dss_accreditor"
            # t.date "pci_dss_date"
            # t.text "pci_dss_exclusions"
            # t.boolean "soc_1"
            # t.boolean "soc_2"
            # t.string "secure_development_approach"
            # t.string "penetration_testing_frequency"
            # t.string "penetration_testing_approach"
            # t.text "outage_channel_types", default: [], array: true
            # t.text "outage_channel_other"
            # t.text "metrics_contents"
            # t.text "metrics_channel_types", default: [], array: true
            # t.text "metrics_channel_other"
            # t.text "usage_channel_types", default: [], array: true
            # t.text "usage_channel_other"
          end
        end
      end
    end

    namespace :export do

      #
      # Exports data from the following tables:
      # sellers, seller_addresses, products
      # Does NOT export:
      # seller_accreditations, seller_applications, seller_awards, seller_engagements
      #
      desc "Export all sellers as a csv file which can be loaded into a spreadsheet"
      task csv: :environment do
        filename_sellers = 'exported_sellers.csv'
        filename_products = 'exported_products.csv'
        puts "Writing exported sellers to #{filename_sellers}..."
        CSV.open(filename_sellers, 'w') do |csv|
          headers = Seller.new.attributes.keys.map{|key| "seller.#{key}"}
          # Figure out the maximum number of addresses that any seller has
          max_addresses = SellerAddress.group(:seller_id).count.values.max
          (1..max_addresses).each do |i|
            # TODO: Don't output seller_id attribute
            headers += SellerAddress.new.attributes.keys.map{|key| "seller_address.#{i}.#{key}"}
          end
          csv << headers
          Seller.find_each do |seller|
            # TODO: Convert arrays to something more easy to read/write
            values = seller.attributes.values
            seller.addresses.each do |address|
              # TODO: Don't output seller_id attribute
              values += address.attributes.values
            end
            csv << values
          end
        end
        puts "Writing exported products to #{filename_products}..."
        CSV.open(filename_products, 'w') do |csv|
          headers = Product.new.attributes.keys.map{|key| "product.#{key}"}
          csv << headers
          Product.find_each do |product|
            values = product.attributes.values
            csv << values
          end
        end
      end
    end
  end
end
