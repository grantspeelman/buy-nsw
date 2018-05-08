class Sellers::Applications::DisclosuresController < Sellers::Applications::QuestionGroupController
  layout '../sellers/applications/disclosures/_layout'

private
  def operation_class
    Sellers::SellerApplication::Disclosures::Update
  end

  def operation_present_class
    Sellers::SellerApplication::Disclosures::Update::Present
  end
end
