class Ops::DeactivateBuyer < ApplicationService
  def initialize(buyer_id:)
    @buyer_id = buyer_id
  end

  def buyer
    @buyer ||= Buyer.find(buyer_id)
  end

  def call
    if buyer.may_make_inactive? && buyer.make_inactive!
      self.state = :success
    else
      self.state = :failure
    end
  end

private
  attr_reader :buyer_id
end
