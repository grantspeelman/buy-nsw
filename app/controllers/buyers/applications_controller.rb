class Buyers::ApplicationsController < Buyers::BaseController
  before_action :authenticate_user!, except: :manager_approve
  layout '../buyers/applications/_layout'

  def new
    run Buyers::BuyerApplication::Create do |result|
      return redirect_to buyers_application_path(result[:application_model].id)
    end

    redirect_to buyers_dashboard_path
  end

  def show
    @operation = run Buyers::BuyerApplication::Update::Present
  end

  def update
    params[:buyer_application] ||= {}

    @operation = run Buyers::BuyerApplication::Update do |result|
      if result['result.submitted'] == true
        return redirect_to buyers_dashboard_path
      else
        flash.notice = I18n.t('buyers.applications.messages.changes_saved')
        return redirect_to buyers_application_step_path(result[:application_model].id, result['result.next_step_slug'])
      end
    end

    render :show
  end

  def manager_approve
    @operation = run Buyers::BuyerApplication::ManagerApprove

    flash.notice = (operation['result.approved'] == true) ?
      I18n.t('buyers.applications.messages.manager_approve_success') :
        I18n.t('buyers.applications.messages.manager_approve_failure')

    return redirect_to root_path
  end

private
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
