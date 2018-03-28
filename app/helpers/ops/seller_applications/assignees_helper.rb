module Ops::SellerApplications::AssigneesHelper
  def available_assignees
    User.admin
  end
end
