module Sellers::SellerApplication::Tailor::Contract
  class BusinessDetails < Base
    property :name,         on: :seller
    property :abn,          on: :seller

    validation :default do
      required(:seller).schema do
        configure do
          def abn?(value)
            ABN.valid?(value)
          end
        end

        required(:name).filled
        required(:abn).filled(:abn?)
      end
    end
  end
end
