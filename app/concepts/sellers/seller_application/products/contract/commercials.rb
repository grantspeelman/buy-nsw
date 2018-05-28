module Sellers::SellerApplication::Products::Contract
  class Commercials < Base
    property :free_version, on: :product
    property :free_version_details, on: :product

    property :free_trial, on: :product
    property :free_trial_url, on: :product

    property :pricing_currency, on: :product
    property :pricing_currency_other, on: :product
    property :pricing_min, on: :product
    property :pricing_max, on: :product
    property :pricing_unit, on: :product
    property :pricing_variables, on: :product
    property :pricing_calculator_url, on: :product

    property :education_pricing, on: :product
    property :education_pricing_eligibility, on: :product
    property :education_pricing_differences, on: :product

    property :not_for_profit_pricing, on: :product
    property :not_for_profit_pricing_eligibility, on: :product
    property :not_for_profit_pricing_differences, on: :product

    validation :default, inherit: true do
      configure do
        def currency?(value)
          begin
            Money::Currency.new(value)
          rescue Money::Currency::UnknownCurrency
            false
          end
        end
      end

      required(:product).schema do
        required(:free_version).filled(:bool?)
        required(:free_version_details).maybe(max_word_count?: 50)

        rule(free_version_details: [:free_version, :free_version_details]) do |radio, field|
          radio.true?.then(field.filled?)
        end

        required(:free_trial).filled(:bool?)
        required(:free_trial_url).maybe(:str?, :url?)

        rule(free_trial_url: [:free_trial, :free_trial_url]) do |radio, field|
          radio.true?.then(field.filled?)
        end

        required(:pricing_currency).filled
        required(:pricing_currency_other).maybe(:str?, :currency?)

        rule(pricing_currency_other: [:pricing_currency, :pricing_currency_other]) do |type, field|
          type.eql?('other').then(field.filled?)
        end

        required(:pricing_min).filled(:number?)
        required(:pricing_max).filled(:number?)
        required(:pricing_unit).filled(:str?)

        required(:pricing_variables).filled(:str?)
        required(:pricing_calculator_url).maybe(:str?, :url?)

        required(:education_pricing).filled(:bool?)
        required(:education_pricing_eligibility).maybe(:str?)
        required(:education_pricing_differences).maybe(:str?)

        rule(education_pricing_eligibility: [:education_pricing, :education_pricing_eligibility]) do |radio, field|
          radio.true?.then(field.filled?)
        end
        rule(education_pricing_differences: [:education_pricing, :education_pricing_differences]) do |radio, field|
          radio.true?.then(field.filled?)
        end

        required(:not_for_profit_pricing).filled(:bool?)
        required(:not_for_profit_pricing_eligibility).maybe(:str?)
        required(:not_for_profit_pricing_differences).maybe(:str?)

        rule(not_for_profit_pricing_eligibility: [:not_for_profit_pricing, :not_for_profit_pricing_eligibility]) do |radio, field|
          radio.true?.then(field.filled?)
        end
        rule(not_for_profit_pricing_differences: [:not_for_profit_pricing, :not_for_profit_pricing_differences]) do |radio, field|
          radio.true?.then(field.filled?)
        end
      end
    end
  end
end
