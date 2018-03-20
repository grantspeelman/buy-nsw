require 'rails_helper'

RSpec.describe 'Searching products', type: :feature, js: true do

  let(:section) { 'applications-services' }
  let!(:product_1) {
    create(:active_product,
      name: 'Cloud-o-matic',
      summary: 'Summary',
      section: section,
      audiences: ['developers'],
    )
  }
  let!(:product_2) {
    create(:active_product,
      name: 'Cloud-o-matic Unlimited',
      summary: 'Summary',
      section: section,
      audiences: ['data-analytics'],
    )
  }

  it 'returns a result for a given term' do
    visit pathway_search_path(section)

    fill_in 'q', with: 'Unlimited'
    click_on 'Search'

    within '.results' do
      expect(page.all('li').size).to eq(1)
      expect(page).to have_content(:li, product_2.name)
    end
  end

  it 'can filter by audience' do
    visit pathway_search_path(section)

    fill_in 'q', with: 'Cloud-o-matic'
    click_on 'Search'

    expect(page.all('.results li').size).to eq(2)

    within '.filters' do
      check 'Data and analytics'
    end
    click_on 'Apply filters'

    expect(page.all('.results li').size).to eq(1)

    within '.results' do
      expect(page).to have_content(:li, product_2.name)
    end
  end

end
