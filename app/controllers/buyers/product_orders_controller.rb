class Buyers::ProductOrdersController < ApplicationController
  def new
    # TODO: Make only usable to approved buyers
    @product = Product.find(params[:id])
    @form = Buyers::ProductOrder::Contract.new(ProductOrder.new)
  end

  def create
    @form = Buyers::ProductOrder::Contract.new(ProductOrder.new)
    @product = Product.find(params[:product_id])
    if @form.validate(params[:buyers_product_order_contract])
      @form.save do |hash|
        ProductOrder.create(hash.merge(
          buyer_id: current_user.buyer.id,
          product_id: @product.id,
          product_updated_at: @product.updated_at
        ))
      end
      # TODO: Send confirmation email
      # TODO: Redirect somewhere
      render :show
    else
      render :new
    end
  end
end
