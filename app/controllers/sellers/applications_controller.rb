class Sellers::ApplicationsController < Sellers::BaseController
  before_action :authenticate_user!
  layout '../sellers/applications/_layout'

  def new
    if existing_application.present?
      redirect_to sellers_application_path(existing_application)
    elsif current_user.seller.present?
      redirect_to sellers_dashboard_path
    else
      seller = Seller.create!(owner: current_user)
      application = seller.applications.create!

      redirect_to sellers_application_path(application)
    end
  end

  def show
    @operation = run Sellers::SellerApplication::Update::Present
  end

  def update
    params[:seller_application] ||= {}

    @operation = run Sellers::SellerApplication::Update do |result|
      if result['result.submitted'] == true
        return redirect_to sellers_dashboard_path
      else
        return redirect_to sellers_application_step_path(result[:application_model].id, result['result.next_step_slug'])
      end
    end

    render :show
  end

private
  def existing_application
    @existing_application ||= current_user.seller_applications.created.first
  end

  def form
    operation["contract.default"]
  end
  helper_method :form

  def operation
    @operation
  end
  helper_method :operation

  def application
    form.model[:application]
  end
  helper_method :application

  def _run_options(options)
    options.merge( "current_user" => current_user )
  end

end
