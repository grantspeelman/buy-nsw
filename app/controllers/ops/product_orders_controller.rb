class Ops::ProductOrdersController < Ops::BaseController
  def index
  end

private
  def search
    @search ||= Search::ProductOrders.new(
      selected_filters: params,
      default_values: {},
      page: params.fetch(:page, 1),
      per_page: 25,
    )
  end
  helper_method :search

end
