class ProductOrderMailer < ApplicationMailer
  def order_created_email
    @product_order = params[:product_order]

    mail(
      to: @product_order.buyer.user.email,
      subject: "buy.nsw: Your order for #{@product_order.product.name} (Order ##{@product_order.id})",
    )
  end

end
