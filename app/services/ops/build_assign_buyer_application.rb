class Ops::BuildAssignBuyerApplication < ApplicationService
  def initialize(buyer_application_id:)
    @buyer_application_id = buyer_application_id
  end

  def call
    if buyer_application.present?
      self.state = :success
    else
      self.state = :failure
    end
  end

  def form
    @form ||= Ops::BuyerApplication::Contract::Assign.new(buyer_application)
  end

  def buyer_application
    @buyer_application ||= BuyerApplication.find(buyer_application_id)
  end

private
  attr_reader :buyer_application_id

end
