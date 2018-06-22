require 'rails_helper'

RSpec.describe 'Buyer dashboard', type: :feature, user: :buyer_user do

  it 'shows a message to buyers awaiting review' do
    buyer = create(:inactive_buyer, user: @user)
    create(:ready_for_review_buyer_application, buyer: buyer)

    visit '/'
    click_on 'Your buyer account'

    expect(page).to have_content('Your buyer account')
    expect(page).to have_content('Your buyer application is now being reviewed')
  end

  it 'shows a message to buyers with an active profile' do
    buyer = create(:active_buyer, user: @user)

    visit '/'
    click_on 'Your buyer account'

    expect(page).to have_content('Your buyer account')
    expect(page).to have_content('Your buyer account is active')
  end


end
