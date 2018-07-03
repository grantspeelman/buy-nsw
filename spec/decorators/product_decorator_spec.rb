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

  describe '#pricing_currency' do
    context 'when not "other"' do
      before(:each) {
        allow(product).to receive(:pricing_currency).and_return('usd')
      }

      it 'returns the existing value' do
        expect(subject.pricing_currency).to eq('usd')
      end
    end

    context 'when "other"' do
      before(:each) {
        allow(product).to receive(:pricing_currency).and_return('other')
        allow(product).to receive(:pricing_currency_other).and_return('foo')
      }

      it 'returns the existing value' do
        expect(subject.pricing_currency).to eq('foo')
      end
    end
  end

  shared_examples_for '#parse_money' do |value_method, decorator_method|
    let(:value) { BigDecimal.new("100.00") }

    before(:each) {
      allow(product).to receive(:pricing_currency).and_return(currency)
      allow(product).to receive(value_method).and_return(value)
    }

    context 'when a currency exists' do
      let(:currency) { 'aud' }

      it 'returns a money object' do
        expect(subject.send(decorator_method)).to be_a(Money)
      end

      it 'sets the correct currency' do
        expect(subject.send(decorator_method).currency).to eq(currency)
      end

      it 'sets the correct value' do
        expect(subject.send(decorator_method).format).to eq('$100.00')
      end
    end

    context 'when a currency is invalid' do
      let(:currency) { 'foo' }

      it 'returns nil' do
        expect(subject.send(decorator_method)).to be_nil
      end
    end

    context 'when a currency is blank' do
      let(:currency) { nil }

      it 'returns nil' do
        expect(subject.send(decorator_method)).to be_nil
      end
    end
  end

  shared_examples_for '#formatted_pricing_*' do |value_method, decorator_method|
    let(:money) { Money.new('10000', :aud) }

    before(:each) {
      expect(subject).to receive(value_method).and_return(money)
    }

    it 'formats a money object as currency' do
      expect(subject.send(decorator_method)).to eq('$100.00 AUD')
    end
  end

  describe '#pricing_min_with_currency' do
    it_should_behave_like '#parse_money', :pricing_min, :pricing_min_with_currency
  end

  describe '#pricing_max_with_currency' do
    it_should_behave_like '#parse_money', :pricing_max, :pricing_max_with_currency
  end

  describe '#formatted_pricing_min' do
    it_should_behave_like '#formatted_pricing_*', :pricing_min_with_currency, :formatted_pricing_min
  end

  describe '#formatted_pricing_max' do
    it_should_behave_like '#formatted_pricing_*', :pricing_max_with_currency, :formatted_pricing_max
  end

end
