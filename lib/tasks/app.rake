require 'csv'

namespace :app do
  namespace :sellers do
    namespace :export do

      desc "Export all sellers as a csv file which can be loaded into a spreadsheet"
      task csv: :environment do
        filename = 'exported_sellers.csv'
        puts "Writing exported sellers to #{filename}..."
        CSV.open(filename, 'w') do |csv|
          # TODO: Generate header based on first seller attributes
          csv << Seller.first.attributes.keys
          Seller.find_each do |seller|
            # TODO: Convert arrays to something more easy to read/write
            csv << seller.attributes.values
          end
        end
      end
    end
  end
end
