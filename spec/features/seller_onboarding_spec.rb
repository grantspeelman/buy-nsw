require 'rails_helper'

RSpec.describe 'Seller onboarding', type: :feature, js: true do

  it 'submits a successful application' do
    visit '/'
    click_on 'Apply as a seller'

    complete_introduction
    fill_in_business_basics
    fill_in_business_details
    fill_in_contact_details
    fill_in_disclosures
    upload_documents
    fill_in_tools
    fill_in_recognition
    fill_in_industry
    fill_in_services
    add_products
    complete_declaration

    expect(page).to have_content('Your seller application has been submitted.')
  end

  def complete_introduction
    click_on 'Start application'
  end

  def fill_in_business_basics
    fill_in 'Business name', with: 'Test Pty Ltd'
    fill_in 'ABN', with: '10 123 456 789'
    fill_in 'Summary', with: 'A summary of my business'
    fill_in 'Website URL', with: 'http://example.org'
    fill_in 'LinkedIn URL', with: 'http://linkedin.com/example'

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

    click_on 'Save and continue'
  end

  def fill_in_industry
    check 'ICT'
    click_on 'Save and continue'
  end

  def fill_in_business_details
    choose '2 to 19 employees'
    check 'Start-up'
    check 'Not for profit'
    check 'Regional'
    check 'Indigenous'
    check 'Yes, with local government'
    check 'Yes, with federal government'
    click_on 'Save and continue'
  end

  def fill_in_contact_details
    within_fieldset 'Business contact' do
      fill_in 'Name', with: 'Winston Smith-Churchill'
      fill_in 'Email address', with: 'test@example.org'
      fill_in 'Phone', with: '0412 345 678'
    end
    within_fieldset 'Authorised representative' do
      fill_in 'Name', with: 'Churchill Smith-Winston'
      fill_in 'Email address', with: 'example@test.org'
      fill_in 'Phone', with: '0487 654 321'
    end
    click_on 'Save and continue'
  end

  def fill_in_disclosures
    fill_in_disclosure :structural_changes, 'No'
    fill_in_disclosure :investigations, 'Yes', 'Further details'
    fill_in_disclosure :legal_proceedings, 'No'
    fill_in_disclosure :insurance_claims, 'Yes', 'Further details'
    fill_in_disclosure :conflicts_of_interest, 'Yes', 'Further details'
    fill_in_disclosure :other_circumstances, 'No'
    click_on 'Save and continue'
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

  def upload_documents
    expiry_date = 1.year.from_now

    within_fieldset 'Financial statement' do
      attach_file 'Upload a file', example_pdf, make_visible: true

      fill_in 'Day', with: expiry_date.day
      fill_in 'Month', with: expiry_date.month
      fill_in 'Year', with: expiry_date.year
    end
    within_fieldset 'Professional Indemnity' do
      attach_file 'Upload a file', example_pdf, make_visible: true

      fill_in 'Day', with: expiry_date.day
      fill_in 'Month', with: expiry_date.month
      fill_in 'Year', with: expiry_date.year
    end
    within_fieldset 'Workers Compensation' do
      attach_file 'Upload a file', example_pdf, make_visible: true

      fill_in 'Day', with: expiry_date.day
      fill_in 'Month', with: expiry_date.month
      fill_in 'Year', with: expiry_date.year
    end

    click_on 'Upload documents'
  end

  def example_pdf
    Rails.root.join('spec', 'fixtures', 'files', 'example.pdf')
  end

  def fill_in_tools
    fill_in 'Tools', with: 'Some tools'
    fill_in 'Methodologies', with: 'Much methodologies'
    fill_in 'Technologies', with: 'Many technologies'
    click_on 'Save and continue'
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

    click_on 'Save and continue'
  end

  def fill_in_services
    check 'Cloud services'
    check 'Data and analytics'
    check 'Training and learning'

    click_on 'Save and continue'
  end

  def add_products
    fill_in 'Name', with: 'My friendly product'
    click_on 'Save'

    click_on 'Save and continue'
  end

  def complete_declaration
    check 'I am Churchill Smith-Winston, an authorised representative of Test Pty Ltd (ABN: 10 123 456 789)'
    click_on 'Submit application'
  end

end
