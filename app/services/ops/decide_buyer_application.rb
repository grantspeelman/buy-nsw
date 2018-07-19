class Ops::DecideBuyerApplication < ApplicationService
  extend Forwardable

  def_delegators :build_operation, :buyer_application, :form

  def initialize(buyer_application_id:, current_user:, attributes:)
    @buyer_application_id = buyer_application_id
    @current_user = current_user
    @attributes = attributes
  end

  def call
    begin
      raise Failure unless build_operation.success?

      ActiveRecord::Base.transaction do
        assign_and_validate_attributes
        change_application_state
        set_timestamp
        persist_buyer_application
        log_event
        notify_user_by_email
      end

      self.state = :success
    rescue Failure
      self.state = :failure
    end
  end

private
  attr_reader :buyer_application_id, :current_user, :attributes

  def build_operation
    @build_operation ||= Ops::BuildDecideBuyerApplication.call(
      buyer_application_id: buyer_application_id
    )
  end

  def assign_and_validate_attributes
    raise Failure unless form.validate(attributes)
  end

  def change_application_state
    case form.decision
    when 'approve' then buyer_application.approve
    when 'reject' then buyer_application.reject
    end
  end

  def set_timestamp
    buyer_application.decided_at = Time.now
  end

  def persist_buyer_application
    raise Failure unless form.save
  end

  def log_event
    params = {
      user: current_user,
      eventable: buyer_application,
      note: form.decision_body,
    }

    case form.decision
    when 'approve' then Event::ApprovedApplication.create(params)
    when 'reject' then Event::RejectedApplication.create(params)
    end
  end

  def notify_user_by_email
    mailer = BuyerApplicationMailer.with(application: buyer_application)

    case form.decision
    when 'approve' then mailer.application_approved_email.deliver_later
    when 'reject' then mailer.application_rejected_email.deliver_later
    end
  end

end
