require 'rails_helper'

RSpec.describe 'Seller waitlist invitations', type: :feature, js: true, skip_login: true do

  it 'can accept an invitation' do
    seller = create(:invited_waiting_seller)
    password = 'a strong password'

    visit sellers_waitlist_invitation_path(seller.invitation_token)

    fill_in 'Password', with: password
    fill_in 'Confirm', with: password

    click_on 'Continue'

    within 'header .user' do
      expect(page).to have_content(seller.contact_email)
    end

    click_on 'Start application'

    expect(page).to have_field('Business name', with: seller.name)

    formatted_abn = ABN.new(seller.abn).to_s
    expect(page).to have_field('ABN', with: formatted_abn)
  end
end
