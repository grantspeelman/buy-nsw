class Sellers::Applications::RootController < Sellers::Applications::BaseController
  before_action :assert_application_presence!, except: :new

  def new
    run Sellers::SellerApplication::Create do |result|
      return redirect_to sellers_application_path(result[:application_model].id)
    end

    redirect_to sellers_dashboard_path
  end

  def submit
    @operation = run Sellers::SellerApplication::Submit::Present
  end

  def do_submit
    @operation = run Sellers::SellerApplication::Submit do |result|
      return redirect_to sellers_dashboard_path
    end

    render :submit
  end

private
  attr_reader :operation
  helper_method :operation

  def steps
    Sellers::Applications::StepsController.steps
  end
  helper_method :steps

  def presenter
    @presenter ||= Sellers::Applications::DashboardPresenter.new(
      application,
      steps,
    )
  end
  helper_method :presenter

  def submit_form
    @operation ||= run(Sellers::SellerApplication::Submit::Present)
  end
  helper_method :submit_form

  def assert_application_presence!
    raise NotFound unless application.present?
  end
end
