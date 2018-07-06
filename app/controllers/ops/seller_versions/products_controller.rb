class Ops::SellerVersions::ProductsController < Ops::BaseController
  layout '../ops/seller_versions/_layout'

  def show
  end

private
  def application
    @application ||= SellerVersion.find(params[:seller_application_id])
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
