class Pathways::SearchController < ApplicationController

private
  def search
    @search ||= Search::Product.new(
      term: params[:q],
      section: params[:section],
      selected_filters: params.except(:q, :section),
      page: params.fetch(:page, 1),
      per_page: 25,
    )
  end
  helper_method :search

  def section
    params[:section]
  end
  helper_method :section

end
