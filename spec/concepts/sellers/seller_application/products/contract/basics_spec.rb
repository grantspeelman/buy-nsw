require 'rails_helper'

RSpec.describe Sellers::SellerApplication::Products::Contract::Basics do
  let(:product) { create(:inactive_product) }
  let(:application) { create(:created_seller_application) }

  subject { Sellers::SellerApplication::Products::Contract::Basics.new(
    application: application,
    product: product
  ) }

  let(:atts) {
    {
      name: 'Product-o-tron 2000',
      summary: "We name you product so you don't have to",
      audiences: ['developers'],
      reseller_type: 'extra-support',
      organisation_resold: 'The Original Cloud Co',
      custom_contact: true,
      contact_name: 'Other Contact',
      contact_email: 'other@example.org',
      contact_phone: '01234 567890',
      features: [
        { feature: 'It does things' },
      ],
      benefits: [
        { benefit: 'It benefits you' },
      ],
    }
  }

  it 'can save with valid attributes' do
    subject.validate(atts)

    expect(subject).to be_valid
    expect(subject.save).to eq(true)
  end

  it 'is invalid when the name is blank' do
    subject.validate(atts.merge(name: nil))

    expect(subject).to_not be_valid
    expect(subject.errors[:name]).to be_present
  end
end
