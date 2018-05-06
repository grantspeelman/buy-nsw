module Sellers::SellerApplication::Profile::Contract
  class Basics < Base
    property :summary,      on: :seller
    property :website_url,  on: :seller
    property :linkedin_url, on: :seller

    validation :default, inherit: true  do
      required(:seller).schema do
        required(:summary).filled(max_word_count?: 50)
        required(:website_url).filled
      end
    end
  end
end
