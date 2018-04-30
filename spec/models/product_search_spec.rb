require 'rails_helper'
require_relative 'concerns/search/seller_tag_filters'

RSpec.describe ProductSearch do

  it_behaves_like 'Concerns::Search::SellerTagFilters', term: 'test', section: 'section'

end
