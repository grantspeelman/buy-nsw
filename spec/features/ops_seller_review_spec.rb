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

      click_navigation_item 'Documents'

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

    it 'tells the user when a seller is exempt from workers compensation insurance' do
      seller = create(:seller, workers_compensation_exempt: true)
      application = create(:awaiting_assignment_seller_application, seller: seller)
      visit ops_seller_application_path(application)

      click_navigation_item 'Documents'

      within_document ops_field_label(:workers_compensation_certificate) do
        expect(page).to have_content('Not required')
      end
    end

    it 'tags sellers who were invited from the waitlist' do
      application = create(:awaiting_assignment_seller_application)
      create(:joined_waiting_seller, seller: application.seller)
      visit ops_seller_application_path(application)

      within '.current-view' do
        expect(page).to have_content('This seller was invited')
      end
    end

    context 'with uploaded terms for a product' do
      let!(:application) { create(:awaiting_assignment_seller_application) }
      let!(:product) { create(:inactive_product, :with_basic_details, seller: application.seller) }

      context 'for an unscanned document' do
        let!(:document) { create(:unscanned_document, documentable: product, kind: 'terms') }

        before(:example) {
          visit ops_seller_application_path(application)
          click_navigation_item(product.name)
        }

        it 'shows a holding message' do
          within_product_detail('Additional terms document') do
            expect(page).to have_content(document.original_filename)
            expect(page).to have_content('awaiting virus scan')
          end
        end
      end

      context 'for a clean document' do
        let!(:document) { create(:clean_document, documentable: product, kind: 'terms') }

        before(:example) {
          visit ops_seller_application_path(application)
          click_navigation_item(product.name)
        }

        it 'shows a download button' do
          within_product_detail('Additional terms document') do
            expect(page).to have_content(document.original_filename)
            expect(page).to have_link('View document')
          end
        end
      end

      context 'for an infected document' do
        let!(:document) { create(:infected_document, documentable: product, kind: 'terms') }

        before(:example) {
          visit ops_seller_application_path(application)
          click_navigation_item(product.name)
        }

        it 'shows an error message' do
          within_product_detail('Additional terms document') do
            expect(page).to have_content(document.original_filename)
            expect(page).to have_content('infected file')
          end
        end
      end
    end

    it 'shows seller recognition details' do
      application = create(:awaiting_assignment_seller_application)

      accreditation = create(:seller_accreditation, seller: application.seller)
      engagement = create(:seller_engagement, seller: application.seller)
      award = create(:seller_award, seller: application.seller)

      visit ops_seller_application_path(application)
      click_navigation_item 'Seller details'

      within_definition ops_field_label(:accreditations) do
        expect(page).to have_content(accreditation.accreditation)
      end

      within_definition ops_field_label(:engagements) do
        expect(page).to have_content(engagement.engagement)
      end

      within_definition ops_field_label(:awards) do
        expect(page).to have_content(award.award)
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
    click_navigation_item 'Seller details'
    click_navigation_item 'Documents'
    click_navigation_item 'Application'
  end

  def browse_product(product)
    click_navigation_item product.name
    click_navigation_item 'Application'
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

  def click_navigation_item(label)
    within '.right-col nav' do
      click_on label
    end
  end

  def within_product_detail(label, &block)
    within_definition(label, &block)
  end

  def within_definition(label, &block)
    term = page.find(:xpath, "//dt[contains(text(),'#{label}')]/following-sibling::dd[1]")
    within(term, &block)
  end

end
