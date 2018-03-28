class Ops::SellerApplicationsController < Ops::BaseController

  def assign
    run Ops::SellerApplication::Assign::Present
  end

  def update_assign
    run Ops::SellerApplication::Assign do |result|
      return redirect_to ops_seller_applications_path
    end

    render :assign
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

  def form
    @form
  end
  helper_method :form

end
