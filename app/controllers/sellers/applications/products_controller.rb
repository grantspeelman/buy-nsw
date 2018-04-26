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

  def update
    @operation = run operation_class do |result|
      if result['result.completed'] == true
        return redirect_to sellers_application_path(result[:application_model])
      else
        return redirect_to result['result.next_step'].path
      end
    end

    render :show
  end

private
  def operation_class
    Sellers::SellerApplication::Products::Update
  end

  def operation_present_class
    Sellers::SellerApplication::Products::Update::Present
  end
end
