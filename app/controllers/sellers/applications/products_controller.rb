class Sellers::Applications::ProductsController < Sellers::Applications::QuestionGroupController
  layout -> {
    action_name == 'index' ? '../sellers/applications/shared/_layout' : '../sellers/applications/products/_layout'
  }

  def index
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

  def products
    application.seller.products.order('name ASC')
  end
  helper_method :products

  def progress_report
    @progress_report ||= SellerApplicationProgressReport.new(
      application: application,
      question_sets: [],
      product_question_set: operation_present_class,
    )
  end
  helper_method :progress_report

  def operation_class
    Sellers::SellerApplication::Products::Update
  end

  def operation_present_class
    Sellers::SellerApplication::Products::Update::Present
  end
end
