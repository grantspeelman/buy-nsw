class Ops::SellersController < Ops::BaseController

  after_action :set_content_disposition, if: :csv_request?, only: :index

  def index
    respond_to do |format|
      format.html
      format.csv
    end
  end

private
  def search
    @search ||= Search::Ops::Seller.new(
      selected_filters: params,
      default_values: {
        state: 'active',
      },
      page: params.fetch(:page, 1),
      per_page: 25,
    )
  end
  helper_method :search

  def csv_filename
    "sellers-#{search.selected_filters_string}-#{Time.now.to_i}.csv"
  end
end
