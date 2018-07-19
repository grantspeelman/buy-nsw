class Buyers::ProductOrdersController < Buyers::BaseController
  before_action :validate_active_buyer!

  def new
    @operation = CreateProductOrder.new(
      user: current_user,
      product_id: params[:id],
    )
  end

  def create
    @operation = CreateProductOrder.call(
      user: current_user,
      product_id: params[:id],
      attributes: params,
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
