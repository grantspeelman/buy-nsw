class Sellers::Applications::BusinessDetailsForm < Sellers::Applications::BaseForm
  property :name,         on: :seller
  property :abn,          on: :seller
  property :summary,      on: :seller
  property :website_url,  on: :seller
  property :linkedin_url, on: :seller

  validates :name, :abn, :summary, :website_url, presence: true
end
