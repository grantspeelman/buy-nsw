class Sellers::Applications::QuestionGroupController < Sellers::Applications::BaseController
  before_action :restrict_access_unless_tailored!

  def show
    @operation = run operation_present_class
  end

  def update
    params[:seller_application] ||= {}

    @operation = run operation_class do |result|
      flash.notice = I18n.t('sellers.applications.messages.changes_saved')

      if result['result.completed']
        return redirect_to sellers_application_path(result[:application_model])
      else
        return redirect_to result['result.next_step'].path
      end
    end

    flash.now.alert = I18n.t('sellers.applications.messages.changes_saved_with_errors')
    render :show
  end

private
  def operation_class
    raise('Sellers::Applications::QuestionGroupController invoked without defining operation_class')
  end

  def operation_present_class
    raise('Sellers::Applications::QuestionGroupController invoked without defining operation_present_class')
  end

  # NOTE: Don't allow sellers to change their information once they have already
  # completed the tailor question group
  #
  def restrict_access_unless_tailored!
    unless application.tailor_complete?
      redirect_to tailor_sellers_application_path(application)
    end
  end

  def form
    operation["contract.default"]
  end
  helper_method :form

  def operation
    @operation
  end
  helper_method :operation

  def seller
    operation[:seller_model]
  end
  helper_method :application

end
