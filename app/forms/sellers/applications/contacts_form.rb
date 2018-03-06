class Sellers::Applications::ContactsForm < Sellers::Applications::BaseForm
  property :contact_name,          on: :seller
  property :contact_email,         on: :seller
  property :contact_phone,         on: :seller

  property :representative_name,   on: :seller
  property :representative_email,  on: :seller
  property :representative_phone,  on: :seller
end
