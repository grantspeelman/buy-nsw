class Ops::SellerApplicationsController < Ops::BaseController

  layout ->{
    action_name == 'index' ? 'ops' : '../ops/seller_applications/_layout'
  }

  def show
    if application.may_assign?
      run Ops::SellerApplication::Assign::Present
    elsif application.may_approve?
      run Ops::SellerApplication::Decide::Present
    end
  end

  def assign
    run Ops::SellerApplication::Assign::Present
  end

  def update_assign
    run Ops::SellerApplication::Assign do |result|
      return redirect_to ops_seller_applications_path
    end

    render :assign
  end

  def decide
    run Ops::SellerApplication::Decide do |result|
      return redirect_to ops_seller_applications_path
    end

    render :show
  end

private
  def applications
    @applications ||= SellerApplication.includes(:seller)
  end
  helper_method :applications

  def search
    @search ||= SellerApplicationSearch.new(
      selected_filters: params,
    )
  end
  helper_method :search

  def application
    @application ||= SellerApplication.find(params[:id])
  end
  helper_method :application

  def form
    @form
  end
  helper_method :form

end
