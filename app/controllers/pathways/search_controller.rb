class Pathways::SearchController < ApplicationController

private
  def search
    @search ||= ProductSearch.new(
      term: params[:q],
      section: params[:section],
      selected_filters: params.except(:q, :section),
    )
  end
  helper_method :search

  def section
    params[:section]
  end
  helper_method :section

end
