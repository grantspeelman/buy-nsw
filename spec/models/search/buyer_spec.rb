require 'rails_helper'

RSpec.describe Search::Buyer do

  it 'returns all buyers by default' do
    create_list(:buyer, 10)

    search = Search::Buyer.new(
      selected_filters: {}
    )

    expect(search.results.size).to eq(10)
  end

  it 'filters by state' do
    create_list(:buyer, 5, state: 'inactive')
    create_list(:buyer, 3, state: 'active')

    search = Search::Buyer.new(
      selected_filters: {
        state: 'inactive'
      }
    )

    expect(search.results.size).to eq(5)
  end

  it 'filters by term' do
    buyer_1 = create(:buyer, name: 'John')
    buyer_2 = create(:buyer, name: 'Jane')

    search = Search::Buyer.new(
      selected_filters: {
        term: 'Jane'
      }
    )

    expect(search.results).to contain_exactly(buyer_2)
  end

end
