class CreateProductOrder < ApplicationService
  extend Forwardable

  def_delegators :build_operation, :buyer, :product, :product_order, :form

  def initialize(user:, product_id:, attributes: {})
    @user = user
    @product_id = product_id
    @attributes = attributes
  end

  def call
    begin
      raise Failure unless build_operation.success?

      ActiveRecord::Base.transaction do
        assign_and_validate_attributes
        set_order_details
        persist_product_order
        send_confirmation_email
        send_slack_notification
      end

      self.state = :success
    rescue Failure
      self.state = :failure
    end
  end

private
  attr_reader :user, :product_id, :attributes

  def build_operation
    @build_operation ||= BuildProductOrder.call(
      user: user,
      product_id: product_id,
    )
  end

  def assign_and_validate_attributes
    raise Failure unless form.validate(attributes)
  end

  def set_order_details
    product_order.product_updated_at = product.updated_at
  end

  def persist_product_order
    form.save
  end

  def send_confirmation_email
    mailer = ProductOrderMailer.with(product_order: product_order)
    mailer.order_created_email.deliver_later
  end

  def send_slack_notification
    SlackPostJob.perform_later(product_order.id, :new_product_order.to_s)
  end

end
