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

  def seller_version
    self.model[:seller_version]
  end

  # NOTE: This is deprecated and `seller_version` should be used instead.
  def application
    seller_version
  end
end
