module Concerns::Contracts::SellerApplication
  extend ActiveSupport::Concern

  included do
    model :application
  end

  def seller_id
    seller.id
  end

  def seller
    self.model[:seller]
  end

  def application
    self.model[:application]
  end
end
