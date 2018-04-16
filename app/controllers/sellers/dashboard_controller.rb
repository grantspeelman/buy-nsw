class Sellers::DashboardController < Sellers::BaseController
  before_action :authenticate_user!
  before_action :validate_seller!

  def show; end

private
  def seller
    @seller ||= current_user.seller
  end
  helper_method :seller

  def validate_seller!
    if seller.blank? || seller.applications.first.state == 'created'
      redirect_to new_sellers_application_path
    end
  end
end
