class Buyers::ProductOrdersController < Buyers::BaseController
  before_action :validate_active_buyer!

  def new
    @operation = run Buyers::ProductOrder::Create::Present
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

  def _run_options(options)
    options.merge(
      'config.current_user' => current_user,
    )
  end

  def contract
    if action_name == 'create'
      operation.form
    else
      operation['contract.default']
    end
  end

  def product
    if action_name == 'create'
      operation.product
    else
      operation['model.product']
    end
  end

  helper_method :contract, :operation, :product
end
