module Sellers::SellerApplication::Products::Contract
  class Commercials < Base
    property :free_version, on: :product
    property :free_version_details, on: :product

    property :free_trial, on: :product
    property :free_trial_url, on: :product

    property :pricing_min, on: :product
    property :pricing_max, on: :product
    property :pricing_unit, on: :product
    property :pricing_variables, on: :product
    property :pricing_variables_other, on: :product
    property :pricing_calculator_url, on: :product

    property :education_pricing, on: :product
    property :education_pricing_eligibility, on: :product
    property :education_pricing_differences, on: :product

    validation :default, inherit: true do
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

        required(:pricing_min).filled(:number?)
        required(:pricing_max).filled(:number?)
        required(:pricing_unit).filled(:str?)

        required(:pricing_variables).value(one_of?: Product.pricing_variables.values)
        required(:pricing_variables_other).maybe(:str?)
        required(:pricing_calculator_url).maybe(:str?, :url?)

        rule(pricing_variables_other: [:pricing_variables, :pricing_variables_other]) do |checkboxes, field|
          checkboxes.contains?('other').then(field.filled?)
        end

        required(:education_pricing).filled(:bool?)
        required(:education_pricing_eligibility).maybe(:str?)
        required(:education_pricing_differences).maybe(:str?)

        rule(education_pricing_eligibility: [:education_pricing, :education_pricing_eligibility]) do |radio, field|
          radio.true?.then(field.filled?)
        end
        rule(education_pricing_differences: [:education_pricing, :education_pricing_differences]) do |radio, field|
          radio.true?.then(field.filled?)
        end
      end
    end
  end
end
