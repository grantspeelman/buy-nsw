class Sellers::Applications::InvitationsController < Sellers::Applications::BaseController
  skip_before_action :authenticate_user!, only: [:accept, :update_accept]

  def new
    @operation = run Sellers::SellerVersion::Invitation::Create::Present

    if params[:email].present?
      operation['contract.default'].email = params[:email]
    end
  end

  def create
    @operation = run Sellers::SellerVersion::Invitation::Create do |result|
      flash.notice = I18n.t('sellers.applications.messages.invitation_sent', email: result['model'].email)
      return redirect_to sellers_application_path(result[:application_model])
    end

    render :new
  end

  def accept
    @operation = run Sellers::SellerVersion::Invitation::Accept::Present

    if operation.failure?
      flash.alert = I18n.t('sellers.applications.messages.invitation_invalid')
      redirect_to root_path
    end
  end

  def update_accept
    @operation = run Sellers::SellerVersion::Invitation::Accept do |result|
      sign_in(result['model'])

      flash.notice = I18n.t('sellers.applications.messages.invitation_accepted')
      return redirect_to sellers_application_path(result[:application_model])
    end

    render :accept
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
    @application ||= current_user.seller_versions.created.find(params[:application_id])
  end

  def owners
    application.owners
  end
  helper_method :owners
end
