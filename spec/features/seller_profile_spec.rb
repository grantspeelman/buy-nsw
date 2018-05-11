require 'rails_helper'

RSpec.describe 'Seller profiles', type: :feature, js: true, user: :active_buyer_user do

  let(:abn) { '24 138 089 942' }
  let(:compact_abn) { abn.gsub(/\s/, '') }

  let(:seller) { create(:active_seller, abn: compact_abn) }

  it 'can display a seller profile' do
    visit sellers_profile_path(seller)

    expect(page).to have_content(:h1, seller.name)

    within '.intro' do
      expect(page).to have_content(seller.summary)
    end

    within '#basic-details' do
      expect_list_entry('Website', seller.website_url)
      expect_list_entry('Business contact',
        seller.contact_name,
        seller.contact_phone,
        seller.contact_email
      )
    end

    within '#company-details' do
      expect_list_entry('Authorised representative',
        seller.representative_name,
        seller.representative_phone,
        seller.representative_email
      )
      expect_list_entry('ABN', abn)
      expect_list_entry('Location',
        seller.addresses.first.address,
        seller.addresses.first.suburb,
        seller.addresses.first.state_text,
        seller.addresses.first.postcode
      )
      expect_list_entry('Accreditations', seller.accreditations.first.accreditation)
      expect_list_entry('Industry engagement', seller.engagements.first.engagement)
    end

    within '#recognition' do
      expect_list_entry('Awards', seller.awards.first.award)
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
