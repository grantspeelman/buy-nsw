require 'rails_helper'

RSpec.describe 'Seller profiles', type: :feature, js: true, skip_login: true do

  let(:abn) { '24 138 089 942' }
  let(:compact_abn) { abn.gsub(/\s/, '') }

  let!(:version) { create(:approved_seller_version, abn: compact_abn) }
  let!(:seller) { version.seller }

  context 'not signed in' do
    it 'can display a restricted seller profile' do
      visit sellers_profile_path(seller)

      expect(page).to have_content(:h1, version.name)

      expect(page).to have_content('Website')
      expect(page).to have_no_content('Business contact')
      expect(page).to have_no_content('Authorised representative')
      expect(page).to have_content('ABN')
      expect(page).to have_no_content('Location')
      expect(page).to have_content('Accreditations')
      expect(page).to have_content('Industry engagement')
      expect(page).to have_content('Awards')
    end

    it 'should tell you what you need to do to see the full seller profile' do
      visit sellers_profile_path(seller)

      expect(page).to have_content('To see the full seller profile, create a buyer account, or sign in')
    end
  end

  context 'signed in as inactive buyer' do
    before :each do
      @user = create(:buyer_user)
      sign_in @user
    end

    it 'should tell you what you need to do to see the full seller profile' do
      visit sellers_profile_path(seller)

      expect(page).to have_content('To see the full seller profile you need to be an approved buyer')
    end
  end

  context 'signed in as active buyer' do
    before :each do
      @user = create(:active_buyer_user)
      sign_in @user
    end

    it 'does not tell you how to see the full seller profile' do
      visit sellers_profile_path(seller)

      expect(page).to have_no_content('To see the full seller profile')
    end

    it 'can display a seller profile' do
      visit sellers_profile_path(seller)

      expect(page).to have_content(:h1, version.name)

      within '.intro' do
        expect(page).to have_content(version.summary)
      end

      within '#basic-details' do
        expect_list_entry('Website', version.website_url)
        expect_list_entry('Business contact',
          version.contact_name,
          version.contact_phone,
          version.contact_email
        )
      end

      within '#company-details' do
        expect_list_entry('Authorised representative',
          version.representative_name,
          version.representative_phone,
          version.representative_email
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
  end

  def expect_list_entry(label, *contents)
    term = page.find('dt', text: label)

    contents.each do |content|
      definition = term.sibling('dd', text: content)
      expect(definition).to be_present
    end
  end
end
