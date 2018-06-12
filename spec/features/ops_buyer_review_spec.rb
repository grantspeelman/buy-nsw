require 'rails_helper'

RSpec.describe 'Reviewing buyer applications', type: :feature, js: true do

  describe 'as an admin user', user: :admin_user do
    it 'can approve an application' do
      application = create(:awaiting_assignment_buyer_application)

      visit '/ops'
      click_on 'Buyer applications'
      click_on 'Reset filters'

      select_application_from_list(application.buyer.name)

      expect_application_state('awaiting_assignment')

      assign_application_to(@user.email)

      expect_flash_message('Application assigned')
      expect_application_state('ready_for_review')

      expect_buyer_details(
        'Buyer name' => application.buyer.name,
        'Organisation name' => application.buyer.organisation
      )

      decide_on_application(decision: 'Approve', decision_body: 'Response text')
      expect_flash_message('Application approved')

      expect_application_state('approved')
    end
  end

  def select_application_from_list(buyer_name)
    within '.record-list table' do
      row = page.find('td', text: buyer_name).ancestor('tr')

      within row do
        click_on 'View'
      end
    end
  end

  def assign_application_to(email)
    page.find('h2', text: 'Assign this application').click
    select email, from: 'Assigned to'
    click_on 'Assign'
  end

  def expect_application_state(state)
    within '.status-indicator' do
      expect(page).to have_content(state)
    end
  end

  def expect_flash_message(message)
    within '.messages' do
      expect(page).to have_content(message)
    end
  end

  def expect_buyer_details(details)
    click_on 'Buyer details'

    details.each do |label, value|
      term = page.find('dt', text: label)
      definition = term.sibling('dd', text: value)

      expect(definition).to be_present
    end
  end

  def decide_on_application(decision:, decision_body:)
    click_on 'Application'

    page.find('h2', text: 'Make a decision').click

    within_fieldset 'Outcome' do
      choose decision
    end

    fill_in 'Response', with: decision_body

    click_on 'Make decision'
  end

end
