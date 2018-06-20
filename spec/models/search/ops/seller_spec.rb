require 'rails_helper'

RSpec.describe Search::Ops::Seller do

  it 'returns all sellers' do
    create_list(:active_seller, 5)
    create_list(:inactive_seller, 5)
    search = described_class.new

    expect(search.results.count).to eq(10)
  end

  it 'filters by state' do
    create_list(:active_seller, 5)
    create_list(:inactive_seller, 3)

    search = described_class.new(
      selected_filters: {
        state: 'inactive',
      }
    )

    expect(search.results.size).to eq(3)
  end

end
