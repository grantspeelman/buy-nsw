class Sellers::Applications::LegalsController < Sellers::Applications::QuestionGroupController
  layout '../sellers/applications/legals/_layout'

private
  def operation_class
    Sellers::SellerApplication::Legals::Update
  end

  def operation_present_class
    Sellers::SellerApplication::Legals::Update::Present
  end
end
