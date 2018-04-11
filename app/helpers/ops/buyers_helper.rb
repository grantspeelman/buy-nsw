module Ops::BuyersHelper
  include Ops::FiltersHelper
  include Ops::DetailHelper

  # NOTE: Some of the details displayed here are the same as those in the buyer
  # application screens
  #
  include Ops::BuyerApplications::DetailHelper
end
