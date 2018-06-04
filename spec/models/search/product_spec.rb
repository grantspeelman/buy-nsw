require 'rails_helper'
require_relative '../concerns/search/seller_tag_filters'

RSpec.describe Search::Product do

  it_behaves_like 'Concerns::Search::SellerTagFilters', term: 'test', section: 'section'

  context 'pagination' do
    it 'returns results only for the specific page' do
      section = 'applications-software'
      create_list(:active_product, 8, section: section)

      args = {
        term: nil,
        section: section,
        selected_filters: {},
        per_page: 5,
      }

      first_page = Search::Product.new(args.merge(page: 1))

      expect(first_page.results.size).to eq(8)
      expect(first_page.paginated_results.size).to eq(5)

      second_page = Search::Product.new(args.merge(page: 2))

      expect(second_page.results.size).to eq(8)
      expect(second_page.paginated_results.size).to eq(3)
    end
  end

end
