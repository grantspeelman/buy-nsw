module Ops::RootHelper

  def seller_applications_for_review_count
    SellerVersion.for_review.count
  end

  def assigned_seller_applications_for_review_count
    SellerVersion.assigned_to(current_user).for_review.count
  end

  def buyer_applications_for_review_count
    BuyerApplication.for_review.count
  end

  def assigned_buyer_applications_for_review_count
    BuyerApplication.assigned_to(current_user).for_review.count
  end

end
