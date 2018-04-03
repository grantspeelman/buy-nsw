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
end
