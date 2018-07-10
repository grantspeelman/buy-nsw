require 'rails_helper'

RSpec.describe Ops::WaitingSeller::Contract::Update do

  let(:waiting_seller) { create(:waiting_seller) }
  let(:atts) { attributes_for(:waiting_seller) }

  subject { described_class.new(waiting_seller) }

  it 'is valid with all required atts' do
    form = described_class.new(waiting_seller)
    form.validate(atts)

    expect(form).to be_valid
  end

  assert_invalidity_of_blank_field :name
  assert_invalidity_of_blank_field :contact_name
  assert_invalidity_of_blank_field :contact_email

  it "is invalid when 'state' is not in the list" do
    form = described_class.new(waiting_seller)
    form.validate(atts.merge(state: 'something else'))

    expect(form).to_not be_valid
    expect(form.errors[:state]).to be_present
  end

  it "is invalid when the contact_email already exists for another WaitingSeller" do
    existing_waiting_seller = create(:waiting_seller)

    form = described_class.new(waiting_seller)
    form.validate(atts.merge(
      contact_email: existing_waiting_seller.contact_email
    ))

    expect(form).to_not be_valid
    expect(form.errors[:contact_email]).to be_present
  end

  it "is invalid when the contact_email already exists as a user" do
    existing_user = create(:seller_user)

    form = described_class.new(waiting_seller)
    form.validate(atts.merge(contact_email: existing_user.email))

    expect(form).to_not be_valid
    expect(form.errors[:contact_email]).to be_present
  end

  it "is invalid when the ABN already exists for another WaitingSeller" do
    existing_waiting_seller = create(:waiting_seller)

    form = described_class.new(waiting_seller)
    form.validate(atts.merge(
      abn: existing_waiting_seller.abn
    ))

    expect(form).to_not be_valid
    expect(form.errors[:abn]).to be_present
  end

  it "is invalid when the ABN already exists for a seller" do
    existing_seller = create(:approved_seller_version)

    form = described_class.new(waiting_seller)
    form.validate(atts.merge(abn: existing_seller.abn))

    expect(form).to_not be_valid
    expect(form.errors[:abn]).to be_present
  end

end
