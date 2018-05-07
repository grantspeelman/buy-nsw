class Ops::SellerApplications::ProductsController < Ops::BaseController
  layout '../ops/seller_applications/_layout'

  def show
  end

private
  def application
    @application ||= SellerApplication.find(params[:seller_application_id])
  end
  helper_method :application

  def product
    @product ||= ProductDecorator.new(
      application.seller.products.find(params[:id]),
      view_context,
    )
  end
  helper_method :product
end
