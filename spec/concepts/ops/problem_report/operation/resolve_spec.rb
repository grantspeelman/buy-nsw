require 'rails_helper'

RSpec.describe Ops::ProblemReport::Resolve do

  let(:current_user) { create(:admin_user) }
  let(:problem_report) { create(:open_problem_report) }

  def perform_operation
    described_class.({ id: problem_report.id }, 'config.current_user' => current_user)
  end

  it 'returns a success status' do
    expect(perform_operation).to be_success
  end

  it 'assigns the current user to `resolved_by`' do
    perform_operation
    problem_report.reload

    expect(problem_report.resolved_by).to eq(current_user)
  end

  it 'sets the `resolved_at` timestamp' do
    time = 1.hour.ago

    Timecop.freeze(time) do
      perform_operation
    end

    problem_report.reload

    expect(problem_report.resolved_at.to_i).to eq(time.to_i)
  end

  it 'sets the state to `resolved`' do
    perform_operation
    problem_report.reload

    expect(problem_report.state).to eq('resolved')
  end

  context 'failure states' do
    it 'fails when the report is already resolved' do
      problem_report.update_attribute(:state, 'resolved')

      expect(perform_operation).to be_failure
    end

    it 'fails when the user is missing' do
      expect(
        described_class.({ id: problem_report.id }, 'config.current_user' => nil)
      ).to be_failure
    end
  end

end
