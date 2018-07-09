module Concerns::Contracts::SellerApplication
  extend ActiveSupport::Concern

  included do
    model :seller_version
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
