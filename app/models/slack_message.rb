class SlackMessage
  include Rails.application.routes.url_helpers

  def new_product_order(order)
    buyer = link_to(order.buyer.name, ops_buyer_url(order.buyer))
    product = link_to(order.product.name, pathway_product_url(order.product.section, order.product))
    url = ops_product_orders_url

    message(
      text: I18n.t(
        'slack_messages.new_product_order.text',
        buyer: buyer,
        organisation: order.buyer.organisation,
        product: product,
        url: url
      ),
      attachments: [
        {
          fallback: "#{I18n.t('slack_messages.new_product_order.button')} at #{url}",
          actions: [
            type: "button",
            text: I18n.t('slack_messages.new_product_order.button'),
            url: url
          ]
        }
      ]
    )
  end

  def buyer_application_submitted(application)
    url = ops_buyer_application_url(application)
    buyer = application.buyer.name
    organisation = application.buyer.organisation
    button = I18n.t('slack_messages.buyer_application_submitted.button')

    message(
      text: I18n.t(
        'slack_messages.buyer_application_submitted.text',
        buyer: buyer,
        organisation: organisation
      ),
      attachments: [{
        fallback: "#{button} at #{url}",
        actions: [
          type: "button",
          text: button,
          url: url
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
