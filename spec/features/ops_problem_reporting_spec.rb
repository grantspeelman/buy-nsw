require 'rails_helper'

RSpec.describe 'Submitting a problem report', type: :feature, js: true do

  let(:resolved_message) { I18n.t('ops.problem_reports.messages.resolved') }
  let(:updated_message) { I18n.t('ops.problem_reports.messages.updated') }

  let!(:report) { create(:problem_report) }
  let(:tags) { ['example', 'tags'] }

  describe 'as an admin user', user: :admin_user do
    it 'can resolve a report' do
      visit '/ops'
      click_on 'Problem reports'

      select_report_from_list(report.issue)
      expect_report_state('open')

      tag_report
      expect_flash_message(updated_message)
      expect_tags

      resolve_report
      expect_flash_message(resolved_message)
      expect_report_state('resolved')
    end
  end

  def select_report_from_list(issue)
    within '.record-list table' do
      row = page.find('td', text: issue).ancestor('tr')

      within row do
        click_on 'View'
      end
    end
  end

  def expect_flash_message(message)
    within '.messages' do
      expect(page).to have_content(message)
    end
  end

  def expect_report_state(state)
    within '.report-state' do
      expect(page).to have_content(state)
    end
  end

  def tag_report
    page.find('h2', text: 'Edit the tags').click

    fill_in 'Tags', with: tags.join(' ')
    click_button 'Save'
  end

  def resolve_report
    page.find('h2', text: 'Mark this problem as resolved').click

    click_button 'Mark as resolved'
  end

  def expect_tags
    term = page.find('dt', text: 'Tags')
    definition = term.sibling('dd', text: tags.join(', '))

    expect(definition).to be_present
  end

end
