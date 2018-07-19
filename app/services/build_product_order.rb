class BuildProductOrder < ApplicationService
  def initialize(user:, product_id:)
    @user = user
    @product_id = product_id
  end

  def call
    if active_buyer? && product.present?
      self.state = :success
    else
      self.state = :failure
    end
  end

  def buyer
    @buyer ||= user.buyer
  end

  def product
    @product ||= Product.active.find(product_id)
  end

  def product_order
    @product_order ||= buyer.product_orders.build(product: product)
  end

  def form
    @form ||= Buyers::ProductOrder::Contract::Create.new(product_order)
  end

private
  attr_reader :user, :product_id

  def active_buyer?
    user.present? && user.is_active_buyer?
  end
end
