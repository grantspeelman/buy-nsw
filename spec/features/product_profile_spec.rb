require 'rails_helper'

RSpec.describe 'Showing products', type: :feature, js: true do

  let(:product) { create(:active_product) }

  it 'can display a product page' do
    visit pathway_product_path(product.section, product)

    expect(page).to have_content(:h1, product.name)

    within '.basics' do
      expect(page).to have_content(product.summary)
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
