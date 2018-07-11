module Sellers::SellerVersion::Contract
  class Declaration < Base
    def representative_details_provided?
      [:representative_name, :representative_email, :representative_phone, :representative_position].map {|field|
        seller_version.send(field)
      }.reject(&:present?).empty?
    end

    def business_details_provided?
      seller_version.name.present? && seller_version.abn.present?
    end

    property :agree, on: :seller_version

    validation :default do
      required(:seller_version).schema do
        required(:agree).filled(:bool?, :true?)
      end
    end
  end
end
