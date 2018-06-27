require 'rails_helper'

RSpec.describe ProductDecorator do

  let(:product) { create(:product) }
  let(:mock_context) { double('view context') }

  subject { described_class.new(product, mock_context) }

  describe '#display_additional_terms?' do
    context 'when no document is present' do
      it 'returns false' do
        expect(subject.display_additional_terms?).to be_falsey
      end
    end

    context 'when a document with no attached file is present' do
      before(:each) {
        create(:clean_document, documentable: product, kind: 'terms', document: nil)
      }

      it 'returns false' do
        expect(subject.display_additional_terms?).to be_falsey
      end
    end

    context 'when a clean document is present' do
      before(:each) {
        create(:clean_document, documentable: product, kind: 'terms')
      }

      it 'returns true' do
        expect(subject.display_additional_terms?).to be_truthy
      end
    end

    context 'when an unscanned document is present' do
      before(:each) {
        create(:unscanned_document, documentable: product, kind: 'terms')
      }

      it 'returns false' do
        expect(subject.display_additional_terms?).to be_falsey
      end
    end

    context 'when an infected document is present' do
      before(:each) {
        create(:infected_document, documentable: product, kind: 'terms')
      }

      it 'returns false' do
        expect(subject.display_additional_terms?).to be_falsey
      end
    end
  end

end
