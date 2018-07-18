require 'csv'
require 'factory_bot'

include FactoryBot::Syntax::Methods

namespace :app do
  namespace :sellers do
    namespace :create do

      desc "Create fake sellers data - WARNING deletes MOST data in the database"
      task fake: :environment do
        User.destroy_all
        SellerVersion.destroy_all
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

        (1..20).each do |i|
          seller = create(:active_seller)
          seller_version = create(:approved_seller_version,
            seller_id: seller.id,
            name: Faker::Company.unique.name,
            abn: Faker::Company.unique.australian_business_number,
            summary: Faker::Company.catch_phrase,
            website_url: "https://#{Faker::Internet.domain_name}",
            linkedin_url: "http://linkedin.com/#{Faker::Internet.slug}",
            number_of_employees: SellerVersion.number_of_employees.values.sample,
            start_up: [false, true].sample,
            sme: [false, true].sample,
            not_for_profit: [false, true].sample,
            regional: [false, true].sample,
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
            investigations: false,
            legal_proceedings: false,
            insurance_claims: false,
            conflicts_of_interest: false,
            other_circumstances: false,
            services: services,
            australian_owned: [false, true].sample,
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
          end
        end
      end
    end

    namespace :import do
      desc "Import all sellers from a csv file - WARNING overwrites data in the database"
      task csv: :environment do
        CsvConvert::import_sellers('exported_sellers.csv')
        CsvConvert::import_products('exported_products.csv')
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
        CsvConvert::export_sellers('exported_sellers.csv')
        CsvConvert::export_products('exported_products.csv')
      end
    end
  end
end
