class SlackPostJob < ApplicationJob
  def perform(id, type)
    product_order = ProductOrder.find(id)
    message = SlackMessage.new
    case type.to_sym
    when :new_product_order
      message.new_product_order(product_order)
    else
      raise "Unexpected type"
    end
  end
end
