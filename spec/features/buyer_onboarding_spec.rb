require 'rails_helper'

RSpec.describe 'Buyer onboarding', type: :feature, js: true do

  describe 'as a buyer with a government email', user: :buyer_user_with_approved_email do
    it 'submits a valid employee application' do
      visit '/'
      click_on 'Sign up as a buyer'

      fill_in_buyer_details
      fill_in_employment_status(:employee)
      accept_terms_and_submit

      expect_submission_message
    end

    it 'submits a valid contractor application' do
      visit '/'
      click_on 'Sign up as a buyer'

      fill_in_buyer_details
      fill_in_employment_status(:contractor)
      fill_in_manager_details
      accept_terms_and_submit

      expect_submission_message
    end
  end

  describe 'as a buyer with a non-government email', user: :buyer_user_without_approved_email do
    it 'submits a valid employee application' do
      visit '/'
      click_on 'Sign up as a buyer'

      fill_in_buyer_details
      fill_in_application_body
      fill_in_employment_status(:employee)
      accept_terms_and_submit


    end

    it 'submits a valid contractor application' do
      visit '/'
      click_on 'Sign up as a buyer'

      fill_in_buyer_details
      fill_in_application_body
      fill_in_employment_status(:contractor)
      fill_in_manager_details
      accept_terms_and_submit

      expect_submission_message
    end
  end

  def fill_in_buyer_details
    fill_in 'Full name', with: 'Sir Buy-a-lot'
    fill_in 'Organisation name', with: 'Department of Buying Things'

    click_on 'Save and continue'
  end

  def fill_in_application_body
    fill_in 'buyer_application[application_body]', with: 'I am an authorised buyer from another agency'

    click_on 'Save and continue'
  end

  def fill_in_employment_status(status)
    choose 'I am a NSW Government employee' if status == :employee
    choose 'I am a contractor' if status == :contractor

    click_on 'Save and continue'
  end

  def fill_in_manager_details
    fill_in "Your manager's full name", with: 'Manager Manager'
    fill_in "Your manager's email", with: 'm.manager@example.org'

    click_on 'Save and continue'
  end

  def accept_terms_and_submit
    check 'I agree'

    click_on 'Submit application'
  end

  def expect_submission_message
    expect(page).to have_content('Your application has been submitted.')
  end

end
