module Sellers::SellerVersion::Contract
  class ProfileBasics < Base
    property :summary,      on: :seller_version
    property :website_url,  on: :seller_version
    property :linkedin_url, on: :seller_version

    validation :default, inherit: true  do
      required(:seller_version).schema do
        required(:summary).filled(max_word_count?: 50)
        required(:website_url).filled(:url?)
        optional(:linkedin_url).maybe(:str?, :url?)
      end
    end
  end
end
