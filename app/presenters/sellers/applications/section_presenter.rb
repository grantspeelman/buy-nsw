module Sellers::Applications
  class SectionPresenter
    attr_reader :key
    
    def initialize(key)
      @key = key
    end

    def name
      I18n.t("sellers.applications.sections.#{key}")
    end
  end
end
