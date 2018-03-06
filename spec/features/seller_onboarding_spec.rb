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
    fill_in_services
  end

  def complete_introduction
    expect(page).to have_content('Joining the Digital Marketplace')
    click_on 'Save and continue'
  end

  def fill_in_business_basics
    fill_in 'Business name', with: 'Test Pty Ltd'
    fill_in 'ABN', with: '10 123 456 789'
    fill_in 'Summary', with: 'A summary of my business'
    fill_in 'Website URL', with: 'http://example.org'
    fill_in 'LinkedIn URL', with: 'http://linkedin.com/example'
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
    within_fieldset 'Financial statement' do
      attach_file 'Upload a file', example_pdf, make_visible: true
    end
    within_fieldset 'Professional Indemnity' do
      attach_file 'Upload a file', example_pdf, make_visible: true
    end
    within_fieldset 'Workers Compensation' do
      attach_file 'Upload a file', example_pdf, make_visible: true
    end

    click_on 'Save and continue'
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

end
