class Sellers::Applications::InvitationsController < Sellers::Applications::BaseController
  def new
    @operation = run Sellers::SellerApplication::Invitation::Create::Present
  end

  def create
    @operation = run Sellers::SellerApplication::Invitation::Create do |result|
      flash.notice = I18n.t('sellers.applications.messages.invitation_sent', email: result['model'].email)
      return redirect_to sellers_application_path(result[:application_model])
    end

    render :new
  end

private
  def operation
    @operation
  end
  helper_method :operation

  def form
    operation['contract.default']
  end
  helper_method :form

  def application
    operation[:application_model]
  end
end
