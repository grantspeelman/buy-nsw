require 'rails_helper'

RSpec.shared_examples 'Concerns::Search::SellerTagFilters' do |model_args|
  def args_with_filter(filters)
    model_args.merge(
      selected_filters: {
        business_identifiers: [ filters ].flatten
      }
    )
  end

  def args_without_filter
    args_with_filter([])
  end

  let(:model) { described_class }
  let(:model_args) { model_args } # This allows access to the shared example argument

  let(:relation) { double('Relation') }

  describe '#start_up_filter' do
    it 'calls the scope when key present' do
      expect(relation).to receive(:start_up).and_return('output')

      search = model.new(args_with_filter(:start_up))
      result = search.send(:start_up_filter, relation)

      expect(result).to eq('output')
    end

    it 'returns the relation when key not present' do
      search = model.new(args_without_filter)
      result = search.send(:start_up_filter, relation)

      expect(result).to eq(relation)
    end
  end

  describe '#sme_filter' do
    it 'calls the scope when key present' do
      expect(relation).to receive(:sme).and_return('output')

      search = model.new(args_with_filter(:sme))
      result = search.send(:sme_filter, relation)

      expect(result).to eq('output')
    end

    it 'returns the relation when key not present' do
      search = model.new(args_without_filter)
      result = search.send(:sme_filter, relation)

      expect(result).to eq(relation)
    end
  end

  describe '#disability_filter' do
    it 'calls the scope when key present' do
      expect(relation).to receive(:disability).and_return('output')

      search = model.new(args_with_filter(:disability))
      result = search.send(:disability_filter, relation)

      expect(result).to eq('output')
    end

    it 'returns the relation when key not present' do
      search = model.new(args_without_filter)
      result = search.send(:disability_filter, relation)

      expect(result).to eq(relation)
    end
  end

  describe '#regional_filter' do
    it 'calls the scope when key present' do
      expect(relation).to receive(:regional).and_return('output')

      search = model.new(args_with_filter(:regional))
      result = search.send(:regional_filter, relation)

      expect(result).to eq('output')
    end

    it 'returns the relation when key not present' do
      search = model.new(args_without_filter)
      result = search.send(:regional_filter, relation)

      expect(result).to eq(relation)
    end
  end

  describe '#not_for_profit_filter' do
    it 'calls the scope when key present' do
      expect(relation).to receive(:not_for_profit).and_return('output')

      search = model.new(args_with_filter(:not_for_profit))
      result = search.send(:not_for_profit_filter, relation)

      expect(result).to eq('output')
    end

    it 'returns the relation when key not present' do
      search = model.new(args_without_filter)
      result = search.send(:not_for_profit_filter, relation)

      expect(result).to eq(relation)
    end
  end

  describe '#indigenous_filter' do
    it 'calls the scope when key present' do
      expect(relation).to receive(:indigenous).and_return('output')

      search = model.new(args_with_filter(:indigenous))
      result = search.send(:indigenous_filter, relation)

      expect(result).to eq('output')
    end

    it 'returns the relation when key not present' do
      search = model.new(args_without_filter)
      result = search.send(:indigenous_filter, relation)

      expect(result).to eq(relation)
    end
  end
end
