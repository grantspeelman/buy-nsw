class Sellers::Applications::DisclosuresForm < Sellers::Applications::BaseForm
  property :structural_changes,    on: :seller
  property :investigations,        on: :seller
  property :legal_proceedings,     on: :seller
  property :insurance_claims,      on: :seller
  property :conflicts_of_interest, on: :seller
  property :other_circumstances,   on: :seller

  property :structural_changes_details,    on: :seller
  property :investigations_details,        on: :seller
  property :legal_proceedings_details,     on: :seller
  property :insurance_claims_details,      on: :seller
  property :conflicts_of_interest_details, on: :seller
  property :other_circumstances_details,   on: :seller
end
