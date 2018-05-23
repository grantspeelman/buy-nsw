class Sellers::WaitlistInvitationsController < Sellers::BaseController
  before_action :ensure_user_signed_out!

  def show
    @operation = run Sellers::WaitingSeller::Accept::Present
  end

  def accept
    @operation = run Sellers::WaitingSeller::Accept do |result|
      sign_in(result['user'])
      flash.notice = 'Your account has been created'
      return redirect_to sellers_application_path(result['application'])
    end

    render :show
  end

private
  def ensure_user_signed_out!
    raise NotAuthorized if user_signed_in?
  end

  def operation
    @operation
  end
  helper_method :operation

end
