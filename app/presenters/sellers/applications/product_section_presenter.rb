module Sellers::Applications
  class ProductSectionPresenter < SectionPresenter
    attr_reader :key

    def initialize(key)
      @key = key
    end

    def name
      I18n.t("sellers.applications.products.sections.#{key}")
    end
  end
end
