require 'rails_helper'

RSpec.describe 'Showing products', type: :feature, js: true do

  let(:product) { create(:active_product) }

  it 'can display a product page' do
    visit pathway_product_path(product.section, product)

    expect(page).to have_content(:h1, product.name)

    within '.basics' do
      expect(page).to have_content(product.summary)
    end

    within '.product-metadata' do
      expect_list_entry('Product ID', product.id)
    end
  end

  it 'shows the last updated date' do
    time = Time.parse('1 June 2018')
    product.update_attribute(:updated_at, time)

    visit pathway_product_path(product.section, product)

    within '.last-updated' do
      expect(page).to have_content('Last updated: 1 June 2018')
    end
  end

  def expect_list_entry(label, *contents)
    term = page.find('dt', text: label)

    contents.each do |content|
      definition = term.sibling('dd', text: content)
      expect(definition).to be_present
    end
  end

end
