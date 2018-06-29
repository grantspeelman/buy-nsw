module Search
  class Product < Base
    attr_reader :term, :section

    def initialize(args={})
      @section = args.delete(:section)
      term = args.delete(:term)

      if term.present?
        args[:selected_filters] ||= {}
        args[:selected_filters].merge!(term: term)
      end

      super(args)
    end

    def available_filters
      {
        term: :term_filter,
        audiences: audiences_keys,
        business_identifiers: [:disability, :indigenous, :not_for_profit, :regional, :start_up, :sme],
        characteristics: [:data_in_australia, :api, :mobile_devices],
        reseller_type: [:reseller, :not_reseller],
        security_standards: security_standards_keys,
        pricing: [:free_version, :free_trial, :education],
      }
    end

    def term
      filter_value(:term)
    end

  private
    include Concerns::Search::SellerTagFilters

    def base_relation
      ::Product.with_section(section).active
    end

    def apply_filters(scope)
      scope.yield_self(&method(:term_filter)).
            yield_self(&method(:audiences_filter)).
            yield_self(&method(:start_up_filter)).
            yield_self(&method(:sme_filter)).
            yield_self(&method(:disability_filter)).
            yield_self(&method(:regional_filter)).
            yield_self(&method(:indigenous_filter)).
            yield_self(&method(:not_for_profit_filter)).
            yield_self(&method(:reseller_filter)).
            yield_self(&method(:free_version_filter)).
            yield_self(&method(:free_trial_filter)).
            yield_self(&method(:education_pricing_filter)).
            yield_self(&method(:data_location_filter)).
            yield_self(&method(:api_filter)).
            yield_self(&method(:mobile_devices_filter)).
            yield_self(&method(:security_standards_filter))
    end

    def term_filter(relation)
      if term.present?
        relation = relation.basic_search(term)
      else
        relation
      end
    end

    def audiences_filter(relation)
      relation
      audiences_keys.each do |audience|
        if filter_selected?(:audiences, audience)
          relation = relation.with_audience(audience)
        end
      end
      relation
    end

    def reseller_filter(relation)
      if filter_selected?(:reseller_type, :reseller)
        relation = relation.reseller
      end

      if filter_selected?(:reseller_type, :not_reseller)
        relation = relation.not_reseller
      end

      relation
    end

    def free_version_filter(relation)
      if filter_selected?(:pricing, :free_version)
        relation = relation.free_version
      else
        relation
      end
    end

    def free_trial_filter(relation)
      if filter_selected?(:pricing, :free_trial)
        relation = relation.free_trial
      else
        relation
      end
    end

    def education_pricing_filter(relation)
      if filter_selected?(:pricing, :education)
        relation = relation.education_pricing
      else
        relation
      end
    end

    def data_location_filter(relation)
      if filter_selected?(:characteristics, :data_in_australia)
        relation = relation.with_data_location('only-australia')
      else
        relation
      end
    end

    def api_filter(relation)
      if filter_selected?(:characteristics, :api)
        relation = relation.with_api
      else
        relation
      end
    end

    def mobile_devices_filter(relation)
      if filter_selected?(:characteristics, :mobile_devices)
        relation = relation.mobile_devices
      else
        relation
      end
    end

    def security_standards_filter(relation)
      security_standards_keys.each do |standard|
        if filter_selected?(:security_standards, standard)
          relation = relation.send(standard)
        end
      end
      relation
    end

    def audiences_keys
      ::Product.audiences.values
    end

    def security_standards_keys
      [
        :iso_27001, :iso_27017, :iso_27018, :csa_star, :pci_dss, :soc_2
      ]
    end
  end
end
