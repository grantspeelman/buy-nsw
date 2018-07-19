class Ops::AssignBuyerApplication < ApplicationService
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
        persist_buyer_application
        log_event
      end

      self.state = :success
    rescue Failure
      self.state = :failure
    end
  end

private
  attr_reader :buyer_application_id, :current_user, :attributes

  def build_operation
    @build_operation ||= Ops::BuildAssignBuyerApplication.call(
      buyer_application_id: buyer_application_id
    )
  end

  def assign_and_validate_attributes
    raise Failure unless form.validate(attributes)
  end

  def change_application_state
    buyer_application.assign if buyer_application.may_assign?
  end

  def persist_buyer_application
    raise Failure unless form.save
  end

  def log_event
    Event::AssignedApplication.create(
      user: current_user,
      eventable: buyer_application,
      email: buyer_application.assigned_to.email
    )
  end

end
