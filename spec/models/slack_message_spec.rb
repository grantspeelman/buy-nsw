require 'rails_helper'

RSpec.describe SlackMessage do
  it "#message" do
    expect(RestClient).to receive(:post).with(
      "https://hooks.slack.com/services/abc/def/ghi",
      "{\"text\":\"This is an important message\"}",
      { content_type: :json }
    )

    SlackMessage.message("This is an important message")
  end

  it "#new_product_order" do
    order = create(:product_order)
    expect(SlackMessage).to receive(:message).with(
      text: "<http://localhost:5000/ops/buyers/1|Buyer Buyer> from Organisation Name wants to buy <http://localhost:5000/cloud/applications-software/products/1|Product name>. <http://localhost:5000/ops/product-orders|View product order>."
    )
    SlackMessage.new_product_order(order)
  end
end
