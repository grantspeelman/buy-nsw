require 'rails_helper'

RSpec.describe Ops::WaitingSeller::Contract::Invite do

  it 'is valid with all required atts' do
    form = described_class.new
    form.validate({ ids: [ 1, 2, 3 ]})

    expect(form).to be_valid
  end

  it 'can cast numeric strings to integers' do
    form = described_class.new
    form.validate({ ids: [ '1', '2', '3'] })

    expect(form).to be_valid
  end

  it 'is invalid without the "ids" parameter' do
    form = described_class.new
    form.validate({})

    expect(form).to_not be_valid
    expect(form.errors[:ids]).to be_present
  end

  it 'is invalid when "ids" contains non-integer values' do
    form = described_class.new
    form.validate({ ids: [ 'foo', 'bar', 'baz'] })

    expect(form).to_not be_valid
    expect(form.errors[:ids]).to be_present
  end

end
