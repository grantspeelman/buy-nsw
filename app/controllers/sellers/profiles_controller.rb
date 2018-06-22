class Sellers::ProfilesController < Sellers::BaseController
  def show
  end

private
  def sellers
    @sellers ||= Seller.active
  end
  helper_method :sellers

  def seller
    @seller ||= sellers.find(params[:id])
  end
  helper_method :seller

  def authorized_buyer
    current_user && current_user.buyer.present? && current_user.buyer.active?
  end
  helper_method :authorized_buyer
end
