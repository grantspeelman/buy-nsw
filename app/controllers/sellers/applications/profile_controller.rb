class Sellers::Applications::ProfileController < Sellers::Applications::QuestionGroupController
  layout '../sellers/applications/profile/_layout'

private
  def operation_class
    Sellers::SellerApplication::Profile::Update
  end

  def operation_present_class
    Sellers::SellerApplication::Profile::Update::Present
  end
end
