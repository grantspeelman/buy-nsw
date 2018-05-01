require 'rails_helper'

RSpec.describe Search do

  it 'raises an exception when the base scope has not been set' do
    expect {
      Search.new(
        selected_filters: {},
      ).results
    }.to raise_error(Search::MissingBaseRelation)
  end

  it 'raises an exception when pagination methods are called without a page parameter' do
    class TestSearch < Search
    private
      def base_relation
        Seller.all
      end
    end

    expect {
      TestSearch.new(
        selected_filters: {},
      ).paginated_results
    }.to raise_error(Search::MissingPaginationArgument)
  end

end
