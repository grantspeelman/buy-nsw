class Ops::BuyerApplicationsController < Ops::BaseController

  after_action :set_content_disposition, if: :csv_request?, only: :index

  layout ->{
    action_name == 'index' ? 'ops' : '../ops/buyer_applications/_layout'
  }

  def index
    respond_to do |format|
      format.html
      format.csv
    end
  end

  def assign
    run Ops::BuyerApplication::Assign do |result|
      flash.notice = I18n.t('ops.buyer_applications.messages.update_assign_success')
      return redirect_to ops_buyer_application_path(application)
    end

    render :show
  end

  def decide
    run Ops::BuyerApplication::Decide do |result|
      decision = result['contract.default'].decision
      flash.notice = I18n.t("ops.buyer_applications.messages.decision_success.#{decision}")
      return redirect_to ops_buyer_application_path(application)
    end

    render :show
  end

  def notes
    application = BuyerApplication.find(params[:id])
    event = Event::Note.create(
      user: current_user,
      eventable: application,
      note: params[:event_note]['note']
    )
    redirect_to ops_buyer_application_path(application)
  end

private
  def applications
    @applications ||= BuyerApplication.includes(:seller)
  end
  helper_method :applications

  def search
    @search ||= Search::BuyerApplication.new(
      selected_filters: params,
      default_values: {
        state: 'ready_for_review',
        assigned_to: current_user.id,
      },
      page: params.fetch(:page, 1),
      per_page: 25,
    )
  end
  helper_method :search

  def application
    @application ||= BuyerApplication.find(params[:id])
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
      assign: (run Ops::BuyerApplication::Assign::Present),
      decide: (run Ops::BuyerApplication::Decide::Present),
    }
  end

  def _run_options(options)
    options.merge( "current_user" => current_user )
  end

  def csv_filename
    "buyer-applications-#{search.selected_filters_string}-#{Time.now.to_i}.csv"
  end
end
