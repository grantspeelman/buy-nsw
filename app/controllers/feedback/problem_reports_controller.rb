class Feedback::ProblemReportsController < ApplicationController

  def create
    item = ProblemReport.create(report_params)

    respond_to do |format|
      if item.persisted?
        format.html {
          flash.notice = success_message
          redirect_to(root_path)
        }
        format.json {
          render status: 200, json: { message: success_message }
        }
      else
        format.html { render :new }
        format.json {
          render status: 422, json: { message: invalid_message }
        }
      end
    end
  end

private
  def report_params
    {
      task: params[:task],
      issue: params[:issue],
      url: params[:url],
      referer: params[:referer],
      browser: params[:browser],
      user: (current_user if current_user.present?),
    }
  end

  def success_message
    I18n.t('feedback.problem_report.messages.success')
  end

  def invalid_message
    I18n.t('feedback.problem_report.messages.invalid')
  end

end
