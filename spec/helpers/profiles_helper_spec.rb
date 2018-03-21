require 'rails_helper'

RSpec.describe Sellers::ProfilesHelper, type: :helper do

  describe '#formatted_abn' do
    it 'can format a valid ABN' do
      abn = '12345678910'

      expect(helper.formatted_abn(abn)).to eq('12 345 678 910')
    end

    it 'attempts to format ABNs which are too short' do
      cases = {
        nil => '',
        '12' => '12',
        '1234' => '12 34',
        '1234567' => '12 345 67',
        '123456789' => '12 345 678 9',
      }

      cases.each do |input, output|
        expect(helper.formatted_abn(input)).to eq(output)
      end
    end

  end

end
