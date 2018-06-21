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

  it 'is invalid when the contact email address is not valid' do
    subject.validate(atts.merge(contact_email: 'foo'))

    expect(subject).to_not be_valid
    expect(subject.errors[:contact_email]).to be_present
  end

  describe '#features' do
    it 'is invalid when there are more than 10 features' do
      features = []
      11.times do
        features << { feature: 'It does things' }
      end

      subject.validate(atts.merge(features: features))

      expect(subject).to_not be_valid
      expect(subject.errors[:features]).to be_present
    end

    it 'is valid when the features in excess of 10 are blank' do
      features = []
      10.times do
        features << { feature: 'It does things' }
      end
      2.times do
        features << { feature: '' }
      end
      subject.validate(atts.merge(features: features))

      expect(subject).to be_valid
    end

    context 'prepopulation' do
      it 'prepopulates two features by default' do
        subject.prepopulate!
        expect(subject.features.size).to eq(2)
      end

      it 'only adds one feature when 9 already exist' do
        create_list(:product_feature, 9, product: product)
        subject.prepopulate!
        expect(subject.features.size).to eq(10)
      end

      it 'does not add any extra features when 10 already exist' do
        create_list(:product_feature, 10, product: product)
        subject.prepopulate!
        expect(subject.features.size).to eq(10)
      end

      it 'does not add any extra features when more than 10 already exist' do
        create_list(:product_feature, 15, product: product)
        subject.prepopulate!
        expect(subject.features.size).to eq(15)
      end
    end
  end
end
