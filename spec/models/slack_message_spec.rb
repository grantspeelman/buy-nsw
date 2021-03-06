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
      text: "<#{buyer_url}|Buyer Buyer> from Organisation Name wants to buy <#{product_url}|Product name>. :moneyBag: :tada:",
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

  it '#buyer_application_submitted' do
    application = create(:awaiting_assignment_buyer_application)
    application_url = ops_buyer_application_url(application)

    s = SlackMessage.new
    expect(s).to receive(:message).with(
      text: "Buyer Buyer from Organisation Name just submitted an application to become a buyer. :saxophone: :tada:",
      attachments: [{
        fallback: "Review application at #{application_url}",
        actions: [
          type: 'button',
          text: 'Review application',
          url: application_url
        ]
      }]
    )
    s.buyer_application_submitted(application)
  end

  it '#seller_version_submitted' do
    version = create(:awaiting_assignment_seller_version)
    version_url = ops_seller_application_url(version)

    s = SlackMessage.new
    expect(s).to receive(:message).with(
      text: "#{version.name} just submitted an application to become a seller. :rainbow: :tada:",
      attachments: [{
        fallback: "Review application at #{version_url}",
        actions: [
          type: 'button',
          text: 'Review application',
          url: version_url
        ]
      }]
    )
    s.seller_version_submitted(version)
  end
end
