class Buyers::ProductOrder::Create < Trailblazer::Operation
  class Present < Trailblazer::Operation
    step :ensure_active_buyer!, fail_fast: true
    step :model!
    step Contract::Build( constant: Buyers::ProductOrder::Contract::Create )

    def ensure_active_buyer!(options, **)
      (user = options['config.current_user']) && user.present? && user.is_active_buyer?
    end

    def model!(options, params:, **)
      options['model.buyer'] = options['config.current_user'].buyer
      options['model.product'] = Product.active.find(params[:id])
      options['model'] = options['model.buyer'].product_orders.build(
        product: options['model.product'],
      )
    end
  end

  step Nested(Present)
  step Contract::Validate(key: :product_order)
  step :set_order_details!
  step Contract::Persist()
  step :send_confirmation_email!
  step :send_slack_notification!

  def set_order_details!(options, model:, **)
    model.product_updated_at = options['model.product'].updated_at
  end

  def send_confirmation_email!(options, model:, **)
    mailer = ProductOrderMailer.with(product_order: model)
    mailer.order_created_email.deliver_later
  end

  def send_slack_notification!(options, model:, **)
    SlackPostJob.perform_later(model.id, :new_product_order.to_s)
  end
end
