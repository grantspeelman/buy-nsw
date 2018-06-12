class Ops::ProblemReportsController < Ops::BaseController

  def index; end
  def show; end

  def resolve
    operation = run Ops::ProblemReport::Resolve

    if operation.success?
      flash.notice = I18n.t('ops.problem_reports.messages.resolved')
    else
      flash.alert = I18n.t('ops.problem_reports.messages.resolve_failed')
    end

    redirect_to ops_problem_report_path(operation['model'])
  end

  def tag
    operation = run Ops::ProblemReport::Tag

    if operation.success?
      flash.notice = I18n.t('ops.problem_reports.messages.updated')
    else
      flash.alert = I18n.t('ops.problem_reports.messages.update_failed')
    end

    redirect_to ops_problem_report_path(operation['model'])
  end

private
  def search
    @search ||= Search::ProblemReport.new(
      selected_filters: params,
      default_values: {
        state: 'open',
      },
      page: params.fetch(:page, 1),
      per_page: 25,
    )
  end

  def problem_report
    @problem_report ||= ProblemReport.find(params[:id])
  end

  def operations
    {
      tag: run(Ops::ProblemReport::Tag::Present),
    }
  end

  helper_method :search, :problem_report, :operations

  def _run_options(options)
    options.merge('config.current_user' => current_user)
  end

end
