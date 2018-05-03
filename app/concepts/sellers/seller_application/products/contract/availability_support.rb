module Sellers::SellerApplication::Products::Contract
  class AvailabilitySupport < Base
    property :guaranteed_availability, on: :product
    property :support_options, on: :product
    property :support_hours, on: :product
    property :support_levels, on: :product

    validation :default, inherit: true do
      required(:product).schema do
        required(:guaranteed_availability).filled(max_word_count?: 200)
        required(:support_options).filled(any_checked?: true, one_of?: Product.support_options.values)
        required(:support_hours).filled
        required(:support_levels).filled(max_word_count?: 200)
      end
    end
  end
end
