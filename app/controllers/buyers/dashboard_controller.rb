class Buyers::DashboardController < Buyers::BaseController
  before_action :authenticate_user!
  before_action :validate_buyer!

private
  def buyer
    @buyer ||= current_user.buyer
  end
  helper_method :buyer

  def validate_buyer!
    if buyer.blank? || buyer.application_in_progress?
      redirect_to new_buyers_application_path
    end
  end

end
