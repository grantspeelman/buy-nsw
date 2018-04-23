module Sellers::SellerApplication::Profile::Contract
  class Basics < Base
    property :summary,      on: :seller
    property :website_url,  on: :seller
    property :linkedin_url, on: :seller

    validation :default do
      required(:seller).schema do
        required(:summary).filled
        required(:website_url).filled
      end
    end
  end
end
