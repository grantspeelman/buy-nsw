module Sellers::SellerVersion::Contract
  class BusinessDetails < Base
    property :name,         on: :seller_version
    property :abn,          on: :seller_version

    validation :default, with: {form: true} do
      required(:seller_version).schema do
        configure do
          option :form

          def unique_abn?(value)
            SellerVersion.where.not(seller_id: form.seller.id).where(abn: value).empty?
          end

          def abn?(value)
            ABN.valid?(value)
          end
        end

        required(:name).filled
        required(:abn).filled

        rule(abn: [:abn]) do |abn|
          abn.filled? > abn.unique_abn?
        end
        rule(abn: [:abn]) do |abn|
          abn.filled? > abn.abn?
        end
      end
    end
  end
end
