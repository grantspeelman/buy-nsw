class Ops::SellerApplicationsController < Ops::BaseController

  def index
  end

private
  def applications
    @applications ||= SellerApplication.submitted.includes(:seller)
  end
  helper_method :applications

  def unassigned_applications
    applications.unassigned
  end
  helper_method :unassigned_applications

  def my_applications
    applications.assigned_to(current_user)
  end
  helper_method :my_applications

end
