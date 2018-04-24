class Ops::SellerApplicationsController < Ops::BaseController

  layout ->{
    action_name == 'index' ? 'ops' : '../ops/seller_applications/_layout'
  }

  def show
  end

  def assign
    run Ops::SellerApplication::Assign do |result|
      flash.notice = I18n.t('ops.seller_applications.messages.update_assign_success')
      return redirect_to ops_seller_application_path(application)
    end

    render :show
  end

  def decide
    run Ops::SellerApplication::Decide do |result|
      decision = result['contract.default'].decision
      flash.notice = I18n.t("ops.seller_applications.messages.decision_success.#{decision}")
      return redirect_to ops_seller_application_path(application)
    end

    render :show
  end

  def notes
    application = SellerApplication.find(params[:id])
    event = Event::Note.create(
      user: current_user,
      eventable: application,
      note: params[:event_note]['note']
    )
    redirect_to ops_seller_application_path(application)
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

  def forms
    @forms ||= {
      assign: ops[:assign]['contract.default'],
      decide: ops[:decide]['contract.default'],
    }
  end
  helper_method :forms

  def ops
    @ops ||= {
      assign: (run Ops::SellerApplication::Assign::Present),
      decide: (run Ops::SellerApplication::Decide::Present),
    }
  end

  def _run_options(options)
    options.merge( "current_user" => current_user )
  end
end
