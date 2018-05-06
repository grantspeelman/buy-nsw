require 'rails_helper'

RSpec.describe 'Managing buyers', type: :feature, js: true do

  describe 'as an admin user', user: :admin_user do
    it 'can deactivate a buyer' do
      buyer = create(:active_buyer)

      visit '/ops'
      click_on 'Buyers'

      select_buyer_from_list(buyer.name)
      expect_buyer_state('active')
      deactivate_buyer

      expect_flash_message('Buyer deactivated')
      expect_buyer_state('inactive')
    end
  end

  def select_buyer_from_list(buyer_name)
    within '.record-list table' do
      row = page.find('td', text: buyer_name).ancestor('tr')

      within row do
        click_on 'View'
      end
    end
  end

  def deactivate_buyer
    page.find('h2', text: 'Deactivate this buyer').click
    click_on 'Deactivate'
  end

  def expect_buyer_state(state)
    within '.status-indicator' do
      expect(page).to have_content(state)
    end
  end

  def expect_flash_message(message)
    within '.messages' do
      expect(page).to have_content(message)
    end
  end

end
