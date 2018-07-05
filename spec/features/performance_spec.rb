require 'rails_helper'

RSpec.describe 'Viewing the performance data', type: :feature, js: true do

  it 'can load the performance dashboard' do
    create_list(:created_seller_version, 5)
    create_list(:ready_for_review_seller_version, 3)

    visit performance_path
    expect(page).to have_content('3 completed and in review')
  end

  it 'can load the seller application dashboard' do
    create_list(:created_seller_version, 5)
    create_list(:inactive_seller, 5)

    visit performance_seller_applications_path
  end

end
