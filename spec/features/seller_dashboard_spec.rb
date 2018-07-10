require 'rails_helper'

RSpec.describe 'Seller dashboard', type: :feature do

  it 'shows a message to sellers awaiting review' do
    create(:ready_for_review_seller_version, owner: @user)

    visit '/'
    click_on 'Your seller account'

    expect(page).to have_content('Seller dashboard')
    expect(page).to have_content("We'll be in touch by email soon with the outcome of your application")
  end

  it 'shows a message to sellers with an active profile' do
    create(:approved_seller_version, owner: @user)

    visit '/'
    click_on 'Your seller account'

    expect(page).to have_content('Seller dashboard')
    expect(page).to have_content('Your seller account is active')
  end


end
