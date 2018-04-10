module Ops::AssigneesHelper
  def available_assignees
    User.admin
  end
end
