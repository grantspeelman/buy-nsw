require 'rails_helper'

RSpec.describe Search::BuyerApplication do

  describe '#available_filters' do
    it 'returns all admin users in the assigned_to filter' do
      user = create(:admin_user)
      search = Search::BuyerApplication.new(
        selected_filters: {}
      )

      expect(search.available_filters[:assigned_to]).to eq(
        [
          [ user.email, user.id ]
        ]
      )
    end
  end

  it 'returns all buyer applications by default' do
    create_list(:buyer_application, 10)

    search = Search::BuyerApplication.new(
      selected_filters: {}
    )

    expect(search.results.size).to eq(10)
  end

  it 'filters by assignee' do
    user = create(:admin_user)

    create_list(:buyer_application, 5)
    create_list(:buyer_application, 3, assigned_to: user)

    search = Search::BuyerApplication.new(
      selected_filters: {
        assigned_to: user.id,
      }
    )

    expect(search.results.size).to eq(3)
  end

  it 'filters by state' do
    create_list(:buyer_application, 5, state: 'created')
    create_list(:buyer_application, 3, state: 'ready_for_review')

    search = Search::BuyerApplication.new(
      selected_filters: {
        state: 'created'
      }
    )

    expect(search.results.size).to eq(5)
  end

end
