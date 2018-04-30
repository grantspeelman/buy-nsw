require 'rails_helper'

RSpec.describe 'Seller onboarding', type: :feature, js: true, skip_login: true do

  it 'submits a successful application' do
    visit '/'
    click_on 'Start your application'

    complete_seller_sign_up
    confirm_email_address

    complete_tailor_steps
    complete_contacts_steps
    complete_profile_steps
    complete_documents_steps

    invite_team_member
    accept_invitation
    complete_legals_steps

    submit_application

    expect(page).to have_content('Seller dashboard')
    expect(page).to have_content('Your seller application is under review')
  end

  def complete_seller_sign_up
    fill_in 'Email', with: 'test@test.org'
    fill_in 'Password', with: 'test password'
    fill_in 'Confirm', with: 'test password'
    click_on 'Continue'

    expect(page).to have_content('Confirm your email')
  end

  def confirm_email_address
    token = User.find_by_email('test@test.org').confirmation_token
    visit user_confirmation_path(confirmation_token: token)

    expect(page).to have_content('Thanks for confirming')
  end

  def complete_tailor_steps
    click_on 'Start application'

    # Business details
    fill_in 'Business name', with: 'Test Pty Ltd'
    fill_in 'ABN', with: '10 123 456 789'
    click_on 'Save'

    # Industry
    check 'ICT'
    click_on 'Save'

    # Services
    check 'Cloud products'
    check 'Data and analytics'
    check 'Training and learning'
    click_on 'Save'

    # Review
    click_on 'Continue'
  end

  def complete_contacts_steps
    within '#contacts' do
      click_on 'Start'
    end

    fill_in_contact_details

    click_on_step 'Business address'
    fill_in_address

    go_back_to_application
  end

  def complete_profile_steps
    within '#profile' do
      click_on 'Start'
    end

    fill_in 'Summary', with: 'A summary of my business'
    fill_in 'Website URL', with: 'http://example.org'
    fill_in 'LinkedIn URL', with: 'http://linkedin.com/example'
    click_on 'Save'

    click_on_step 'Business details'
    fill_in_business_details

    click_on_step 'Recognition'
    fill_in_recognition

    go_back_to_application
  end

  def complete_documents_steps
    within '#documents' do
      click_on 'Start'
    end

    upload_document

    click_on_step 'Professional indemnity'
    upload_document

    click_on_step 'Workers compensation'
    upload_document

    go_back_to_application
  end

  def complete_legals_steps
    within '#legals' do
      click_on 'Start'
    end

    fill_in_disclosures

    click_on_step 'Agree terms'
    complete_declaration

    go_back_to_application
  end

  def invite_team_member
    click_on 'Invite'

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

  def fill_in_address
    within_fieldset 'Your business address' do
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
    end
    click_on 'Save'
  end

  def fill_in_business_details
    choose '2 to 19 employees'
    check 'Start-up'
    check 'Not for profit'
    check 'Regional'
    check 'Indigenous'
    check 'Yes, with local government'
    check 'Yes, with federal government'
    click_on 'Save'
  end

  def fill_in_contact_details
    within_fieldset 'Business contact' do
      fill_in 'Name', with: 'Winston Smith-Churchill'
      fill_in 'Email address', with: 'test@example.org'
      fill_in 'Phone', with: '0412 345 678'
    end
    within_fieldset 'Authorised representative' do
      fill_in 'Name', with: 'Churchill Smith-Winston'
      fill_in 'Email address', with: 'authorised@test.org'
      fill_in 'Phone', with: '0487 654 321'
    end
    click_on 'Save'
  end

  def fill_in_disclosures
    fill_in_disclosure :structural_changes, 'No'
    fill_in_disclosure :investigations, 'Yes', 'Further details'
    fill_in_disclosure :legal_proceedings, 'No'
    fill_in_disclosure :insurance_claims, 'Yes', 'Further details'
    fill_in_disclosure :conflicts_of_interest, 'Yes', 'Further details'
    fill_in_disclosure :other_circumstances, 'No'
    click_on 'Save'
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

  def upload_document
    expiry_date = 1.year.from_now

    attach_file 'Upload a file', example_pdf, make_visible: true

    fill_in 'Day', with: expiry_date.day
    fill_in 'Month', with: expiry_date.month
    fill_in 'Year', with: expiry_date.year

    click_on 'Upload document'
  end

  def example_pdf
    Rails.root.join('spec', 'fixtures', 'files', 'example.pdf')
  end

  def fill_in_recognition
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

  def complete_declaration
    check 'I am Churchill Smith-Winston, an authorised representative of Test Pty Ltd (ABN: 10 123 456 789)'
    click_on 'Save'
  end

  def submit_application
    click_on 'Submit application'
  end

  def go_back_to_application
    click_on 'Back to your application'
  end

  def click_on_step(label)
    within '.steps-list' do
      node = page.find('a', text: label)
      node.trigger('click')
    end
  end

end
