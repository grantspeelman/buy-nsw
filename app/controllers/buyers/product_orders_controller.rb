class Buyers::ProductOrdersController < ApplicationController
  def new
    # TODO: Make only usable to approved buyers
    # TODO: Add validation
    @product = Product.find(params[:id])
    @product_order = ProductOrder.new
  end

  def create
    # TODO: Actually create the order
    render :show
  end
end
