require 'rails_helper'

RSpec.describe 'Submitting a problem report', type: :feature, js: true do

  let(:label) { I18n.t('feedback.problem_report.label') }
  let(:task_label) { I18n.t('feedback.problem_report.task') }
  let(:issue_label) { I18n.t('feedback.problem_report.issue') }
  let(:action_label) { I18n.t('feedback.problem_report.action') }
  let(:success_message) { I18n.t('feedback.problem_report.messages.success') }

  def submit_report
    click_on(label)

    fill_in task_label, with: 'Testing'
    fill_in issue_label, with: 'It did not work'

    click_on action_label
    expect(page).to have_content(success_message)
  end

  describe 'when signed out', skip_login: true do
    it 'can submit a report' do
      visit '/cloud'

      submit_report

      report = ProblemReport.last
      expect(report.task).to eq('Testing')
      expect(report.issue).to eq('It did not work')
      expect(report.user).to be_nil
      expect(report.url).to match(/\/cloud$/)
    end
  end

  describe 'when signed in', user: :active_buyer_user do
    it 'sets the user to the current user' do
      visit '/cloud'

      submit_report

      report = ProblemReport.last
      expect(report.user).to eq(@user)
    end
  end

end
