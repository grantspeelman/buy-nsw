class Sellers::Applications::DocumentsController < Sellers::Applications::QuestionGroupController
  layout '../sellers/applications/documents/_layout'

private
  def operation_class
    Sellers::SellerApplication::Documents::Update
  end

  def operation_present_class
    Sellers::SellerApplication::Documents::Update::Present
  end
end
