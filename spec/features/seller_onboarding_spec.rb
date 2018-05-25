require 'rails_helper'

RSpec.describe 'Seller onboarding', type: :feature, js: true, skip_login: true do

  it 'submits a successful application' do
    visit '/register/seller'

    complete_seller_sign_up
    confirm_email_address

    complete_services
    complete_business_details
    complete_contacts
    complete_addresses
    complete_characteristics
    complete_disclosures
    complete_profile_basics
    complete_recognition

    complete_financial_statement
    complete_product_liability
    complete_professional_indemnity
    complete_workers_compensation

    invite_team_member
    accept_invitation
    complete_declaration

    submit_application

    expect(page).to have_content('Seller dashboard')
    expect(page).to have_content('Your seller application is being reviewed')
  end

  def complete_seller_sign_up
    password = SecureRandom.hex(8)

    fill_in 'Email', with: 'test@test.org'
    fill_in 'Password', with: password
    fill_in 'Confirm', with: password
    click_on 'Continue'

    expect(page).to have_content('Confirm your email')
  end

  def confirm_email_address
    token = User.find_by_email('test@test.org').confirmation_token
    visit user_confirmation_path(confirmation_token: token)

    expect(page).to have_content('Thanks for confirming')
  end

  def complete_services
    click_on_step 'services'

    # Services
    check 'Cloud products'
    check 'Training and learning'
    click_on 'Save'
  end

  def complete_business_details
    click_on_step 'business_details'

    # Business details
    fill_in 'Business name', with: 'OpenAustralia Foundation Ltd'
    fill_in 'ABN', with: '24 138 089 942'
    click_on 'Save'
  end

  def complete_contacts
    click_on_step 'contacts'

    within_fieldset 'Business contact' do
      fill_in 'Name', with: 'Winston Smith-Churchill'
      fill_in 'Email address', with: 'test@example.org'
      fill_in 'Phone', with: '0412 345 678'
    end
    within_fieldset 'Authorised representative' do
      fill_in 'Name', with: 'Churchill Smith-Winston'
      fill_in 'Email address', with: 'authorised@test.org'
      fill_in 'Phone', with: '0487 654 321'
      fill_in 'Position', with: 'CEO'
    end
    click_on 'Save'
  end

  def complete_addresses
    click_on_step 'addresses'

    fill_in 'Address', with: '123 Test Street'
    fill_in 'Suburb', with: 'Millers Point'
    select 'New South Wales', from: 'State'
    fill_in 'Postcode', with: '2000'

    click_on 'Add another address'

    within 'ol li:last-of-type' do
      fill_in 'Address', with: '321 Test Street'
      fill_in 'Suburb', with: 'Millers Point'
      select 'New South Wales', from: 'State'
      fill_in 'Postcode', with: '2000'
    end

    click_on 'Save'
  end

  def complete_characteristics
    click_on_step 'characteristics'

    choose '2-4'
    choose 'Standalone organisation'
    check 'Start-up'
    check 'Not for profit'
    check 'Regional'
    check 'Aboriginal'
    check 'Yes, with local government'
    check 'Yes, with federal government'
    click_on 'Save'
  end

  def complete_disclosures
    click_on_step 'disclosures'

    fill_in_disclosure :receivership, 'No'
    fill_in_disclosure :investigations, 'Yes', 'Further details'
    fill_in_disclosure :legal_proceedings, 'No'
    fill_in_disclosure :insurance_claims, 'Yes', 'Further details'
    fill_in_disclosure :conflicts_of_interest, 'Yes', 'Further details'
    fill_in_disclosure :other_circumstances, 'No'
    click_on 'Save'
  end

  def complete_profile_basics
    click_on_step 'profile_basics'

    fill_in 'Summary', with: 'A summary of my business'
    fill_in 'Website URL', with: 'http://example.org'
    fill_in 'LinkedIn URL', with: 'http://linkedin.com/example'
    click_on 'Save'
  end

  def complete_recognition
    click_on_step 'recognition'

    within_fieldset 'Accreditations' do
      fill_in '1', with: 'Certified Pie Eater'
      fill_in '2', with: 'Accredited Cheese Taster'
      click_on 'Add another row'
      fill_in '3', with: 'Verified Beer Drinker'
    end

    within_fieldset 'Industry engagement' do
      fill_in '1', with: 'Wigan Bakers Association board member'
    end

    within_fieldset 'Awards' do
      fill_in '1', with: 'Butter Pie of the Year 2018'
    end

    click_on 'Save'
  end

  def complete_financial_statement
    click_on_step 'financial_statement'
    upload_document
  end

  def complete_product_liability
    click_on_step 'product_liability'
    upload_document
  end

  def complete_professional_indemnity
    click_on_step 'professional_indemnity'
    upload_document
  end

  def complete_workers_compensation
    click_on_step 'workers_compensation'
    check form_label('workers_compensation.workers_compensation_exempt')
    click_on 'Save'
  end

  def complete_declaration
    click_on_step 'declaration'

    check 'I am Churchill Smith-Winston, an authorised representative of OpenAustralia Foundation Ltd (ABN: 24 138 089 942)'
    click_on 'Save'
  end

  def submit_application
    click_on_step 'submit'
    click_on 'Submit application'
  end

  def invite_team_member
    click_on 'Invite your team'
    click_on 'Invite a team member'

    fill_in 'Email', with: 'authorised@test.org'
    click_on 'Send invitation'
  end

  def accept_invitation
    token = User.find_by_email('authorised@test.org').confirmation_token
    application_id = SellerApplication.last.id

    visit accept_sellers_application_invitations_path(application_id, confirmation_token: token)

    fill_in 'Password', with: 'foo bar baz'
    fill_in 'Password confirmation', with: 'foo bar baz'

    click_on 'Accept'

    expect(page).to have_content('accepted')
  end

  def fill_in_disclosure(field, option, details=nil)
    fieldset = "field-#{field.to_s.dasherize}"

    within_fieldset fieldset do
      choose option
      if details
        fill_in 'Please provide details', with: details
      end
    end
  end

  def upload_document(button_label: 'Upload document')
    expiry_date = 1.year.from_now

    attach_file 'Upload a file', example_pdf, make_visible: true

    fill_in 'Day', with: expiry_date.day
    fill_in 'Month', with: expiry_date.month
    fill_in 'Year', with: expiry_date.year

    click_on button_label
  end

  def example_pdf
    Rails.root.join('spec', 'fixtures', 'files', 'example.pdf')
  end

  def click_on_step(key)
    within '.task-list' do
      click_link(step_label(key))
    end
  end

  def step_label(key)
    I18n.t("sellers.applications.steps.#{key}.short")
  end

  def form_label(key)
    I18n.t("activemodel.attributes.sellers.seller_application.contract.#{key}")
  end

end
