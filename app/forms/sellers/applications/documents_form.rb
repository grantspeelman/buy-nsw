class Sellers::Applications::DocumentsForm < Sellers::Applications::BaseForm
  property :financial_statement,                on: :seller
  property :professional_indemnity_certificate, on: :seller
  property :workers_compensation_certificate,   on: :seller
end
