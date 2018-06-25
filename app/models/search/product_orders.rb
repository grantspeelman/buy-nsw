module Search
  class ProductOrders < Base
    include ActionView::Helpers::NumberHelper

    def available_filters
      {
        threshold: {
          "#{number_with_delimiter(ProductOrder::THRESHOLD)} or over": "over",
          "under #{number_with_delimiter(ProductOrder::THRESHOLD)}": "under"
        }
      }
    end

  private
    def base_relation
      ::ProductOrder.all
    end

    def apply_filters(scope)
      scope.yield_self(&method(:threshold_filter))
    end

    def threshold_filter(relation)
      if filter_selected?(:threshold)
        filter_value(:threshold) == "over" ? relation.above_threshold : relation.below_threshold
      else
        relation
      end
    end
  end
end
