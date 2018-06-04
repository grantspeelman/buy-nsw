require 'rails_helper'

RSpec.describe Ops::ProblemReport::Tag do

  let(:problem_report) { create(:open_problem_report) }
  let(:default_params) {
    {
      tags: 'foo bar baz'
    }
  }

  def perform_operation(params: default_params)
    described_class.({ id: problem_report.id, problem_report: params })
  end

  it 'returns a success status' do
    expect(perform_operation).to be_success
  end

  it 'updates the existing problem report' do
    expect { perform_operation }.to change { problem_report.reload.tags }
  end

end
