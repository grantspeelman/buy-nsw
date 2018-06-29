require 'rails_helper'

RSpec.describe 'Searching products', type: :feature, js: true do

  let(:section) { 'applications-software' }
  let(:seller) { create(:active_seller, start_up: true) }
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
      audiences: ['legal'],
      seller: seller,
    )
  }

  it 'returns a result for a given term' do
    visit pathway_search_path(section)

    fill_in 'Keyword search', with: 'Unlimited'
    click_on 'Search'

    within '.results' do
      expect(page.all('.results li.result').size).to eq(1)
      expect(page).to have_content(:li, product_2.name)
    end
  end

  it 'can filter by audience' do
    visit pathway_search_path(section)

    fill_in 'Keyword search', with: 'Cloud-o-matic'
    click_on 'Search'

    expect(page.all('.results li.result').size).to eq(2)

    within '.filters' do
      page.find('label', text: 'Legal').click
    end
    click_on 'Update results'

    expect(page.all('.results li.result').size).to eq(1)

    within '.results' do
      expect(page).to have_content(:li, product_2.name)
    end
  end

  it 'can filter by a tag' do
    visit pathway_search_path(section)

    fill_in 'Keyword search', with: 'Cloud-o-matic'
    click_on 'Search'

    expect(page.all('.results li.result').size).to eq(2)

    within '.filters' do
      page.find('label', text: 'Start-up').click
    end
    click_on 'Update results'

    expect(page.all('.results li.result').size).to eq(1)

    within '.results' do
      expect(page).to have_content(:li, product_2.name)
    end
  end
end
