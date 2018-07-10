class SlackMessage
  include Rails.application.routes.url_helpers

  def new_product_order(order)
    message_type_with_button(
      :new_product_order,
      {
        buyer: link_to(order.buyer.name, ops_buyer_url(order.buyer)),
        organisation: order.buyer.organisation,
        product: link_to(order.product.name, pathway_product_url(order.product.section, order.product))
      },
      ops_product_orders_url
    )
  end

  def buyer_application_submitted(application)
    message_type_with_button(
      :buyer_application_submitted,
      {
        buyer: application.buyer.name,
        organisation: application.buyer.organisation
      },
      ops_buyer_application_url(application)
    )
  end

  def seller_version_submitted(version)
    message_type_with_button(
      :seller_version_submitted,
      {
        seller: version.name
      },
      ops_seller_application_url(version)
    )
  end

  def message_type_with_button(type, params, button_url)
    message_with_button(
      I18n.t("slack_messages.#{type}.text", params),
      I18n.t("slack_messages.#{type}.button"),
      button_url
    )
  end

  def message_with_button(text, button_text, button_url)
    message(
      text: text,
      attachments: [{
        fallback: "#{button_text} at #{button_url}",
        actions: [
          type: "button",
          text: button_text,
          url: button_url
        ]
      }]
    )
  end

  def message(params)
    if slack_webhook_url.present?
      RestClient.post slack_webhook_url, params.to_json, {content_type: :json}
    end
  end

  private

  def link_to(text, url)
    "<#{url}|#{text}>"
  end

  def slack_webhook_url
    ENV["SLACK_WEBHOOK_URL"]
  end
end
