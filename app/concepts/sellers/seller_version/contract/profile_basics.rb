module Sellers::SellerVersion::Contract
  class ProfileBasics < Base
    property :summary,      on: :seller
    property :website_url,  on: :seller
    property :linkedin_url, on: :seller

    validation :default, inherit: true  do
      required(:seller).schema do
        required(:summary).filled(max_word_count?: 50)
        required(:website_url).filled(:url?)
        optional(:linkedin_url).maybe(:str?, :url?)
      end
    end
  end
end
