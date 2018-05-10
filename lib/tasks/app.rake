require 'csv'

namespace :app do
  namespace :sellers do
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
