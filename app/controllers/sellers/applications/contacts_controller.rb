class Sellers::Applications::ContactsController < Sellers::Applications::QuestionGroupController
  layout '../sellers/applications/contacts/_layout'

private
  def operation_class
    Sellers::SellerApplication::Contacts::Update
  end

  def operation_present_class
    Sellers::SellerApplication::Contacts::Update::Present
  end
end
