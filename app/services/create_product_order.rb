class CreateProductOrder
  extend Enumerize

  class Failure < StandardError; end

  enumerize :state, in: [:success, :failure], predicates: true

  def initialize(user:, product_id:, attributes:)
    @user = user
    @product_id = product_id
    @attributes = attributes
  end

  def self.call(*args)
    self.new(*args).tap(&:call)
  end

  def call
    begin
      ActiveRecord::Base.transaction do
        ensure_active_buyer
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

  def buyer
    @buyer ||= user.buyer
  end

  def product
    @product ||= Product.active.find(product_id)
  end

  def product_order
    @product_order ||= buyer.product_orders.build(product: product)
  end

  def form
    @form ||= Buyers::ProductOrder::Contract::Create.new(product_order)
  end

private
  attr_reader :user, :product_id, :attributes

  def ensure_active_buyer
    raise Failure unless user.present? && user.is_active_buyer?
  end

  def set_order_details
    product_order.product_updated_at = product.updated_at
  end

  def persist_product_order
    product_order.save
  end

  def send_confirmation_email
    mailer = ProductOrderMailer.with(product_order: product_order)
    mailer.order_created_email.deliver_later
  end

  def send_slack_notification
    SlackPostJob.perform_later(product_order.id, :new_product_order.to_s)
  end

end
