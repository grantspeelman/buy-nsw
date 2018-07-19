require 'rails_helper'

RSpec.describe Ops::BuildDecideBuyerApplication do

  let(:application) { create(:ready_for_review_buyer_application) }

  subject { described_class.new(buyer_application_id: application.id) }

  describe '.call' do
    let(:operation) { described_class.call(buyer_application_id: application.id) }

    context 'given an existing application' do
      it 'is successful' do
        expect(operation).to be_success
      end
    end

    context 'when the application does not exist' do
      it 'raises an exception' do
        expect{
          described_class.call(buyer_application_id: '1234567')
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when the application is not ready for review' do
      let(:application) { create(:awaiting_assignment_buyer_application) }

      it 'fails' do
        expect(operation).to be_failure
      end
    end
  end

  describe '#form' do
    it 'returns a form for the buyer application' do
      expect(subject.form).to be_a(Ops::BuyerApplication::Contract::Decide)
      expect(subject.form.model).to eq(application)
    end
  end

  describe '#buyer_application' do
    it 'returns the buyer application' do
      expect(subject.buyer_application).to eq(application)
    end
  end

end
