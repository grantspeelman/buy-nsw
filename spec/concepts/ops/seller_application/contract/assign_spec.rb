require 'rails_helper'

RSpec.describe Ops::SellerApplication::Contract::Assign do

  let(:user) { create(:admin_user) }
  let(:application) { create(:seller_application) }

  it 'is valid with an assignee' do
    form = Ops::SellerApplication::Contract::Assign.new(application)

    form.validate(
      assigned_to_id: user.id,
    )

    expect(form).to be_valid
  end

  it 'is invalid without an assignee' do
    form = Ops::SellerApplication::Contract::Assign.new(application)

    form.validate(
       assigned_to_id: nil,
    )

    expect(form).to_not be_valid
    expect(form.errors[:assigned_to_id]).to be_present
  end

end
