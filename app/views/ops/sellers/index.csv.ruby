csv_builder = lambda do |csv|
  csv << ['ID', 'Name', 'Business contact name', 'Business contact email', 'Status', 'Team members']

  search.results.each do |result|
    row = [
      result.id,
      result.name,
      result.contact_name,
      result.contact_email,
      result.state,
    ] + result.owners.map(&:email)

    csv << row
  end
end

CSV.generate(&csv_builder)
