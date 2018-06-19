require 'rails_helper'

RSpec.describe Search::Base do

  it 'raises an exception when the base scope has not been set' do
    expect {
      Search::Base.new(
        selected_filters: {},
      ).results
    }.to raise_error(Search::MissingBaseRelation)
  end

  it 'raises an exception when pagination methods are called without a page parameter' do
    class TestSearch < Search::Base
    private
      def base_relation
        ::Seller.all
      end
    end

    expect {
      TestSearch.new(
        selected_filters: {},
      ).paginated_results
    }.to raise_error(Search::MissingPaginationArgument)
  end

  describe '#selected_filters' do
    class TestSearch < Search::Base
      def available_filters
        {
          filter_one: ['one', 'two', 'three'],
          filter_two: ['four', 'five', 'six'],
        }
      end
    end

    let(:defaults) {
      {
        filter_one: 'one',
        filter_two: 'five',
      }
    }

    it 'returns default values when no filters are set' do
      search = TestSearch.new(
        selected_filters: {},
        default_values: defaults,
      )

      expect(search.selected_filters).to eq(defaults)
    end

    it 'returns only selected values when filters are set' do
      search = TestSearch.new(
        selected_filters: {
          filter_one: 'three'
        },
        default_values: defaults,
      )

      expect(search.selected_filters.keys).to contain_exactly(:filter_one)
    end

    it 'returns no filters when `skip_filters` is set' do
      search = TestSearch.new(
        selected_filters: {
          skip_filters: true,
          filter_one: 'three', # Test that this is ignored
        },
        default_values: defaults,
      )

      expect(search.selected_filters.keys).to be_empty
    end

    it 'permits parameters when an instance of ActionController::Parameters' do
      search = TestSearch.new(
        selected_filters: ActionController::Parameters.new(
          filter_one: 'three',
          unknown_filter: 'evil',
        ),
        default_values: defaults,
      )

      expect(search.selected_filters).to be_a(Hash)
      expect(search.selected_filters.keys).to contain_exactly(:filter_one)
    end
  end

end
