module Search
  class MissingBaseRelation < StandardError; end
  class MissingPaginationArgument < StandardError; end

  class Base
    def initialize(selected_filters: {}, default_values: {}, page: nil, per_page: nil)
      @selected_filters = selected_filters
      @default_values = default_values
      @page = page
      @per_page = per_page
    end

    def results
      @results ||= apply_filters(base_relation)
    end

    def paginated_results
      @paginated_results ||= apply_pagination(results)
    end

    def result_count
      results.size
    end

    def available_filters
      { }
    end

    def selected_filters
      if @selected_filters.keys.map(&:to_s).include?('skip_filters')
        return { skip_filters: true }
      end

      filters = extract_filters_from_parameters(@selected_filters)
      filters.keys.any? ? filters : default_values
    end

    def selected_filters_string
      selected_filters.to_a.flatten.join('-').dasherize.parameterize
    end

    def filter_selected?(filter, option = nil)
      value = filter_value(filter)

      if option.present? && value.present?
        value.is_a?(Array) ? value.map(&:to_s).include?(option.to_s) : value.to_s == option.to_s
      else
        filter_value(filter).present?
      end
    end

    def filter_value(filter)
      selected_filters[filter]
    end

    def active_filters?
      selected_filters.keys.any?
    end

  private
    attr_reader :page, :per_page, :default_values

    def base_relation
      raise(MissingBaseRelation, 'Missing base_relation method. You need to override this in your Search subclass.')
    end

    def apply_filters(scope)
      scope
    end

    def apply_pagination(scope)
      if page
        scope.page(page).per(per_page)
      else
        raise(MissingPaginationArgument, 'Missing the `page` parameter required for pagination. Pass this into your search object, or instead call `results` for the full result list.')
      end
    end

    # When parameters are passed to an instance of a Search class directly from
    # a controller, they are an instance of `ActionController::Parameters`. When
    # this happens, we turn this into an unsafe hash, but restrict only to the
    # filter keys that have been defined.
    #
    # (When this is a plain old hash, we still slice out only the filters we
    # want, which gives us the same outcome.)
    #
    def extract_filters_from_parameters(parameters)
      if parameters.is_a?(ActionController::Parameters)
        parameters.to_unsafe_h.slice(*available_filters.keys).symbolize_keys
      else
        parameters.slice(*available_filters.keys)
      end
    end
  end
end
