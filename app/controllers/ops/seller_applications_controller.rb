class Ops::SellerApplicationsController < Ops::BaseController

  layout ->{
    action_name == 'index' ? 'ops' : '../ops/seller_applications/_layout'
  }

  def show
    assign_op = run Ops::SellerApplication::Assign::Present
    decide_op = run Ops::SellerApplication::Decide::Present

    @assign_form = assign_op['contract.default']
    @decide_form = decide_op['contract.default']
  end

  def update_assign
    run Ops::SellerApplication::Assign do |result|
      flash.notice = 'Application assigned'
      return redirect_to ops_seller_application_path(application)
    end

    render :assign
  end

  def decide
    run Ops::SellerApplication::Decide do |result|
      return redirect_to ops_seller_application_path(application)
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

  def assign_form
    @assign_form
  end
  helper_method :assign_form

  def decide_form
    @decide_form
  end
  helper_method :decide_form

end
