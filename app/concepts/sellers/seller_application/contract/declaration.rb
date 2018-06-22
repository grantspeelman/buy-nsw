module Sellers::SellerApplication::Contract
  class Declaration < Base
    def representative_details_provided?
      [:representative_name, :representative_email, :representative_phone, :representative_position].map {|field|
        seller.send(field)
      }.reject(&:present?).empty?
    end

    def business_details_provided?
      seller.name.present? && seller.abn.present?
    end

    property :agree, on: :seller

    validation :default do
      required(:seller).schema do
        required(:agree).filled(:bool?, :true?)
      end
    end
  end
end
