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
          create(
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
        end
      end
    end

    namespace :export do

      #
      # Exports data from the following tables:
      # sellers, seller_addresses
      # Does NOT export:
      # seller_accreditations, seller_applications, seller_awards, seller_engagements
      #
      desc "Export all sellers as a csv file which can be loaded into a spreadsheet"
      task csv: :environment do
        filename = 'exported_sellers.csv'
        puts "Writing exported sellers to #{filename}..."
        CSV.open(filename, 'w') do |csv|
          headers = Seller.first.attributes.keys.map{|key| "seller.#{key}"}
          # Figure out the maximum number of addresses that any seller has
          max_addresses = SellerAddress.group(:seller_id).count.values.max
          (1..max_addresses).each do |i|
            # TODO: Don't output seller_id attribute
            headers += SellerAddress.first.attributes.keys.map{|key| "seller_address.#{i}.#{key}"}
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
      end
    end
  end
end
