require 'rails_helper'

RSpec.describe 'Viewing the performance data', type: :feature, js: true do

  it 'can load the performance dashboard' do
    create_list(:created_seller_application, 5)

    visit performance_path
    expect(page).to have_content('5 applications started')
  end

end
