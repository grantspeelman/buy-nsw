require 'rails_helper'

RSpec.describe Search do

  it 'raises an exception when the base scope has not been set' do
    expect {
      Search.new(
        selected_filters: {},
      ).results
    }.to raise_error(Search::MissingBaseRelation)
  end

end
