class Sellers::Applications::ProductsController < Sellers::Applications::QuestionGroupController
  layout '../sellers/applications/products/_layout'

  def index
    redirect_to sellers_application_path(params[:application_id])
  end

  def new
    run Sellers::SellerApplication::Products::Create do |result|
      return redirect_to sellers_application_product_path(result[:application_model], result[:product_model])
    end
  end

private
  def application
    @application ||= current_user.seller_applications.created.find(params[:application_id])
  end
  helper_method :application

  def operation_class
    Sellers::SellerApplication::Products::Update
  end

  def operation_present_class
    Sellers::SellerApplication::Products::Update::Present
  end
end
