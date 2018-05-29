module Sellers::SellerApplication::Products::Contract
  class ReportingAnalytics < Base
    property :metrics_contents, on: :product
    property :metrics_channel_types, on: :product
    property :metrics_channel_other, on: :product

    property :outage_channel_types, on: :product
    property :outage_channel_other, on: :product

    property :usage_channel_types, on: :product
    property :usage_channel_other, on: :product

    validation :default, inherit: true do
      required(:product).schema do
        required(:metrics_contents).filled(:str?, max_word_count?: 200)
        required(:metrics_channel_types).filled(any_checked?: true, one_of?: Product.metrics_channel_types.values)
        required(:metrics_channel_other).maybe(:str?)

        rule(metrics_channel_other: [:metrics_channel_types, :metrics_channel_other]) do |checkboxes, field|
          checkboxes.contains?('other').then(field.filled?)
        end

        required(:outage_channel_types).filled(any_checked?: true, one_of?: Product.outage_channel_types.values)
        required(:outage_channel_other).maybe(:str?)

        rule(outage_channel_other: [:outage_channel_types, :outage_channel_other]) do |checkboxes, field|
          checkboxes.contains?('other').then(field.filled?)
        end

        required(:usage_channel_types).filled(any_checked?: true, one_of?: Product.usage_channel_types.values)
        required(:usage_channel_other).maybe(:str?)

        rule(usage_channel_other: [:usage_channel_types, :usage_channel_other]) do |checkboxes, field|
          checkboxes.contains?('other').then(field.filled?)
        end
      end
    end
  end
end
