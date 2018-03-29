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
    @applications ||= SellerApplication.includes(:seller)
  end
  helper_method :applications

  def application
    @application ||= SellerApplication.find(params[:id])
  end
  helper_method :application

  def form
    @form
  end
  helper_method :form

end
