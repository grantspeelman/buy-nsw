require 'rails_helper'

RSpec.describe 'Reviewing seller applications', type: :feature, js: true do

  describe 'as an admin user', user: :admin_user do
    it 'can approve an application' do
      application = create(:awaiting_assignment_seller_application)
      product = create(:inactive_product, :with_basic_details, seller: application.seller)

      visit '/ops'
      click_on 'Seller applications'
      click_on 'Reset filters'

      select_application_from_list(application.seller.name)

      expect_application_state('awaiting_assignment')

      assign_application_to(@user.email)

      expect_flash_message('Application assigned')
      expect_application_state('ready_for_review')

      browse_application_details
      browse_product(product)

      decide_on_application(decision: 'Approve', response: 'Response text')
      expect_flash_message('Application approved')

      expect_application_state('approved')
    end

    it 'can see uploaded documents' do
      application = create(:awaiting_assignment_seller_application)

      create(:clean_document, documentable: application.seller, kind: 'financial_statement')
      create(:unscanned_document, documentable: application.seller, kind: 'professional_indemnity_certificate')
      create(:infected_document, documentable: application.seller, kind: 'workers_compensation_certificate')

      visit '/ops'
      click_on 'Seller applications'
      click_on 'Reset filters'

      select_application_from_list(application.seller.name)

      within '.right-col nav' do
        click_on 'Documents'
      end

      save_page

      within_document ops_field_label(:financial_statement) do
        expect(page).to have_link('View document')
      end
      within_document ops_field_label(:professional_indemnity_certificate) do
        expect(page).to have_content('Awaiting virus scan')
      end
      within_document ops_field_label(:workers_compensation_certificate) do
        expect(page).to have_content('Infected')
      end
    end
  end

  def select_application_from_list(seller_name)
    within '.record-list table' do
      row = page.find('td', text: seller_name).ancestor('tr')

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

  def browse_application_details
    within '.right-col nav' do
      click_on 'Seller details'
      click_on 'Documents'
      click_on 'Application'
    end
  end

  def browse_product(product)
    within '.right-col nav' do
      click_on product.name
      click_on 'Application'
    end
  end

  def decide_on_application(decision:, response:)
    page.find('h2', text: 'Make a decision').click

    within_fieldset 'Outcome' do
      choose decision
    end

    fill_in 'Feedback', with: response

    click_on 'Make decision'
  end

  def within_document(heading_text, &block)
    within 'ul.documents' do
      header = page.find('header', text: heading_text)
      content = header.sibling('.document-details')

      within(content, &block)
    end
  end

  def ops_field_label(key)
    I18n.t("#{key}.name", scope: [ :ops, :seller_applications, :fields ])
  end

end
