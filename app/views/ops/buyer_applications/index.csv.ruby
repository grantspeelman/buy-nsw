csv_builder = lambda do |csv|
  csv << ['ID', 'Buyer name', 'Email', 'Organisation', 'Status', 'Submitted at', 'Assigned to']

  search.results.each do |result|
    csv << [
      result.id,
      result.buyer.name,
      result.user.email,
      result.buyer.organisation,
      result.state,
      result.submitted_at,
      result.assigned_to&.email,
    ]
  end
end

CSV.generate(&csv_builder)
