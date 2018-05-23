require 'rails_helper'

RSpec.describe Ops::WaitingSeller::Contract::Update do

  let(:waiting_seller) { create(:waiting_seller) }
  let(:atts) { attributes_for(:waiting_seller) }

  it 'is valid with all required atts' do
    form = described_class.new(waiting_seller)
    form.validate(atts)

    expect(form).to be_valid
  end

  def self.assert_invalidity_of_blank_field(field)
    it "is invalid when '#{field}' is blank" do
      form = described_class.new(waiting_seller)
      form.validate(atts.merge(field => nil))

      expect(form).to_not be_valid
      expect(form.errors[field]).to be_present
    end
  end

  assert_invalidity_of_blank_field :name
  assert_invalidity_of_blank_field :abn
  assert_invalidity_of_blank_field :address
  assert_invalidity_of_blank_field :suburb
  assert_invalidity_of_blank_field :state
  assert_invalidity_of_blank_field :country
  assert_invalidity_of_blank_field :contact_name
  assert_invalidity_of_blank_field :contact_email
  assert_invalidity_of_blank_field :contact_position
  assert_invalidity_of_blank_field :website_url

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

end
