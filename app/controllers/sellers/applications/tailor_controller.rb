class Sellers::Applications::TailorController < Sellers::Applications::QuestionGroupController
  layout '../sellers/applications/tailor/_layout'

  skip_before_action :restrict_access_unless_tailored!
  before_action :restrict_access_if_completed!

  def update
    params[:seller_application] ||= {}

    @operation = run operation_class do |result|
      if result['result.completed'] == true
        return redirect_to sellers_application_path(result[:application_model])
      else
        flash.notice = I18n.t('sellers.applications.messages.changes_saved')
        return redirect_to result['result.next_step'].path
      end
    end

    flash.now.alert = I18n.t('sellers.applications.messages.changes_saved_with_errors')
    render :show
  end

private

  # NOTE: Don't allow sellers to change their information once they have already
  # completed the tailor question group
  #
  def restrict_access_if_completed!
    if application.tailor_complete?
      redirect_to sellers_application_path(application)
    end
  end

  def operation_class
    Sellers::SellerApplication::Tailor::Update
  end

  def operation_present_class
    Sellers::SellerApplication::Tailor::Update::Present
  end
end
