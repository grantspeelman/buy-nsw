csv_builder = lambda do |csv|
  csv << ['ID', 'Seller name', 'Status', 'Emails']

  search.results.each do |result|
    row = [
      result.id,
      result.seller.name,
      result.state,
    ]
    row += result.seller.owners.map(&:email)

    csv << row
  end
end

CSV.generate(&csv_builder)
