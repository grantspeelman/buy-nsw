module SlackMessage
  def self.new_product_order(order)
    buyer = link_to(order.buyer.name, Rails.application.routes.url_helpers.ops_buyer_url(order.buyer))
    product = link_to(order.product.name, Rails.application.routes.url_helpers.pathway_product_url(order.product.section, order.product))
    view = link_to("View product order", Rails.application.routes.url_helpers.ops_product_order_url(order))
    message("#{buyer} from #{order.buyer.organisation} wants to buy #{product}. #{view}.")
  end

  def self.message(message)
    if slack_webhook_url.present?
      RestClient.post slack_webhook_url, {text: message}.to_json, {content_type: :json}
    end
  end

  private

  def self.link_to(text, url)
    "<#{url}|#{text}>"
  end

  def self.slack_webhook_url
    ENV["SLACK_WEBHOOK_URL"]
  end
end
