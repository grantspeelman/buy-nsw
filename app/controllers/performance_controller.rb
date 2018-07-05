class PerformanceController < ApplicationController

  def index; end

private
  def seller_application_started_count
    SellerVersion.created.count
  end

  def seller_application_in_review_count
    SellerVersion.for_review.count
  end

  def seller_application_approved_count
    SellerVersion.approved.count
  end

  def buyer_application_started_count
    BuyerApplication.created.count
  end

  def buyer_application_in_review_count
    BuyerApplication.for_review.count
  end

  def buyer_application_approved_count
    BuyerApplication.approved.count
  end

  def seller_application_performance_report
    @seller_application_performance_report ||= SellerApplicationPerformanceReport.new
  end

  helper_method :seller_application_started_count, :seller_application_in_review_count,
    :seller_application_approved_count, :buyer_application_started_count,
    :buyer_application_in_review_count, :buyer_application_approved_count,
    :seller_application_performance_report

end
