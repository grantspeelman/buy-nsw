require 'rails_helper'

RSpec.describe SlackMessage do
  include Rails.application.routes.url_helpers

  it "#message" do
    expect(RestClient).to receive(:post).with(
      "https://hooks.slack.com/services/abc/def/ghi",
      "{\"text\":\"This is an important message\"}",
      { content_type: :json }
    )

    SlackMessage.new.message(text: "This is an important message")
  end

  it "#new_product_order" do
    order = create(:product_order)
    buyer_url = ops_buyer_url(order.buyer)
    product_url = pathway_product_url(order.product.section, order.product)
    order_url = ops_product_orders_url

    s = SlackMessage.new
    expect(s).to receive(:message).with(
      text: "<#{buyer_url}|Buyer Buyer> from Organisation Name wants to buy <#{product_url}|Product name>.\n",
      attachments: [{
        fallback: "View product order at #{order_url}",
        actions: [
          type: 'button',
          text: 'View product order',
          url: order_url
        ]
      }]
    )
    s.new_product_order(order)
  end
end
