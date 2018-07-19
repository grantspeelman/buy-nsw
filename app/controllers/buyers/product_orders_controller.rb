class Buyers::ProductOrdersController < Buyers::BaseController
  before_action :validate_active_buyer!

  def new
    @operation = BuildProductOrder.call(
      user: current_user,
      product_id: params[:id],
    )
  end

  def create
    @operation = CreateProductOrder.call(
      user: current_user,
      product_id: params[:id],
      attributes: params[:product_order],
    )

    if operation.success?
      render :show
    else
      render :new
    end
  end

private
  attr_reader :operation

  def contract
    operation.form
  end

  def product
    operation.product
  end

  helper_method :contract, :operation, :product
end
