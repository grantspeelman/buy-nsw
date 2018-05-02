module Sellers::SellerApplication::Products::Contract
  class Basics < Base
    include Concerns::Contracts::Populators

    FeaturePopulator = -> (options) {
      return NestedChildPopulator.call(options.merge(
        params: [:feature],
        model_klass: ProductFeature,
        context: self,
        foreign_key: :product_id,
      ))
    }
    FeaturePrepopulator = ->(_) {
      2.times do
        self.features << ProductFeature.new(product_id: product_id)
      end
    }
    BenefitPopulator = -> (options) {
      return NestedChildPopulator.call(options.merge(
        params: [:benefit],
        model_klass: ProductBenefit,
        context: self,
        foreign_key: :product_id,
      ))
    }
    BenefitPrepopulator = ->(_) {
      2.times do
        self.benefits << ProductBenefit.new(product_id: product_id)
      end
    }

    property :name, on: :product
    property :summary, on: :product
    property :audiences, on: :product

    property :reseller_type, on: :product
    property :organisation_resold, on: :product

    property :custom_contact, on: :product
    property :contact_name, on: :product
    property :contact_email, on: :product
    property :contact_phone, on: :product

    collection :features, on: :product, prepopulator: FeaturePrepopulator, populator: FeaturePopulator do
      property :feature
    end
    collection :benefits, on: :product, prepopulator: BenefitPrepopulator, populator: BenefitPopulator do
      property :benefit
    end

    validation :default, inherit: true do
      required(:product).schema do
        required(:name).filled
        required(:summary).filled

        required(:reseller_type).filled
        required(:organisation_resold).maybe(:str?)

        rule(organisation_resold: [:reseller_type, :organisation_resold]) do |type, field|
          type.excluded_from?(['own-product']).then(field.filled?)
        end

        required(:custom_contact).filled(:bool?)
        optional(:contact_name).maybe(:str?)
        optional(:contact_email).maybe(:str?)
        optional(:contact_phone).maybe(:str?)

        rule(contact_name: [:custom_contact, :contact_name]) do |radio, name|
          radio.true?.then(name.filled?)
        end
        rule(contact_email: [:custom_contact, :contact_email]) do |radio, email|
          radio.true?.then(email.filled?)
        end

        required(:features).value(max_items?: 10)
        required(:benefits).value(max_items?: 10)
      end
    end

  end
end
