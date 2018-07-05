class SlackPostJob < ApplicationJob
  def perform(id, type)
    message = SlackMessage.new
    case type.to_sym
    when :new_product_order
      message.new_product_order(ProductOrder.find(id))
    when :buyer_application_submitted
      message.buyer_application_submitted(BuyerApplication.find(id))
    when :seller_version_submitted
      message.seller_version_submitted(SellerVersion.find(id))
    else
      raise "Unexpected type"
    end
  end
end
