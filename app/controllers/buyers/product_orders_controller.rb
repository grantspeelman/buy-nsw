class Buyers::ProductOrdersController < Buyers::BaseController
  before_action :validate_active_buyer!

  def new
    @operation = run Buyers::ProductOrder::Create::Present
  end

  def create
    @operation = run Buyers::ProductOrder::Create

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
    operation['contract.default']
  end

  def product
    operation['model.product']
  end

  helper_method :contract, :operation, :product
end
