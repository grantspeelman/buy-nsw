module CsvConvert
  def CsvConvert.import
    import_sellers('exported_sellers.csv')
    import_products('exported_products.csv')
  end

  def CsvConvert.export
    export_sellers('exported_sellers.csv')
    export_products('exported_products.csv')
  end

  def CsvConvert.import_sellers(filename)
    puts "Reading in #{filename}..."
    table = CSV.read(filename, headers: true)
    table.each do |row|
      atts = {}
      row.each do |k, v|
        s = k.split('.')
        if s[0] == 'seller'
          atts[s[1]] = v
        end
      end
      atts = unstringify_atts(Seller, atts)

      seller = Seller.find_by(id: atts['id'])
      if seller
        seller.update_attributes(atts)
      else
        Seller.create!(atts)
      end
      # Now do the addresses
      number_of_addresses =
        row.select{|k,v| k.split('.')[0] == 'seller_address'}.map{|k,v| k.split('.')[1].to_i}.max
      (1..number_of_addresses).each do |i|
        atts = {}
        row.each do |k, v|
          s = k.split('.')
          if s[0] == 'seller_address' && s[1] == i.to_s
            atts[s[2]] = v
          end
        end
        address = SellerAddress.find_by(id: atts['id'])
        if address
          address.update_attributes(atts)
        else
          SellerAddress.create!(atts)
        end
      end
    end
  end

  def CsvConvert.import_products(filename)
    puts "Reading in #{filename}..."
    table = CSV.read(filename, headers: true)
    table.each do |row|
      atts = {}
      row.each do |k, v|
        s = k.split('.')
        if s[0] == 'product'
          atts[s[1]] = v
        end
      end
      atts = unstringify_atts(Product, atts)

      product = Product.find_by(id: atts['id'])
      if product
        product.update_attributes(atts)
      else
        Product.create!(atts)
      end
    end
  end

  def CsvConvert.unstringify_atts(klass, atts)
    object = klass.new
    atts.each do |key, value|
      # Check whether this attribute is an enumerize on the original record
      # and if so parse the attribute as if it's been serialised as json
      if object.send(key).kind_of?(Enumerize::Set)
        atts[key] = JSON.parse(atts[key])
      end
    end
    atts
  end

  def CsvConvert.export_sellers(filename)
    puts "Writing exported sellers to #{filename}..."
    CSV.open(filename, 'w') do |csv|
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
  end

  def CsvConvert.export_products(filename)
    puts "Writing exported products to #{filename}..."
    CSV.open(filename, 'w') do |csv|
      headers = Product.new.attributes.keys.map{|key| "product.#{key}"}
      csv << headers
      Product.find_each do |product|
        values = product.attributes.values
        csv << values
      end
    end
  end
end
