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
    operation = Ops::AssignBuyerApplication.call(
      buyer_application_id: params[:id],
      current_user: current_user,
      attributes: params[:buyer_application],
    )

    if operation.success?
      flash.notice = I18n.t('ops.buyer_applications.messages.update_assign_success')
      return redirect_to ops_buyer_application_path(application)
    else
      render :show
    end
  end

  def decide
    operation = Ops::DecideBuyerApplication.call(
      buyer_application_id: params[:id],
      current_user: current_user,
      attributes: params[:buyer_application],
    )

    if operation.success?
      decision = operation.form.decision
      flash.notice = I18n.t("ops.buyer_applications.messages.decision_success.#{decision}")
      return redirect_to ops_buyer_application_path(application)
    else
      render :show
    end
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

  def assign_form
    @assign_form ||= Ops::BuildAssignBuyerApplication.call(buyer_application_id: params[:id]).form
  end
  helper_method :assign_form

  def decide_form
    @decide_form ||= Ops::BuildDecideBuyerApplication.call(buyer_application_id: params[:id]).form
  end
  helper_method :decide_form

  def csv_filename
    "buyer-applications-#{search.selected_filters_string}-#{Time.now.to_i}.csv"
  end
end
