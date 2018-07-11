require 'rails_helper'

RSpec.describe Sellers::SellerVersion::Contract::ProductLiability do

  let(:version) { create(:seller_version) }
  subject { described_class.new(seller_version: version, seller: version.seller) }

  let(:example_pdf) {
    Rack::Test::UploadedFile.new(
      Rails.root.join('spec', 'fixtures', 'files', 'example.pdf'),
      'application/pdf'
    )
  }
  let(:future_date) { Date.today + 1.year }
  let(:historical_date) { Date.today - 1.year }

  context 'when all blank' do
    before(:each) do
      subject.validate(
        "product_liability_certificate_file" => nil,
        "product_liability_certificate_expiry(3i)" => nil,
        "product_liability_certificate_expiry(2i)" => nil,
        "product_liability_certificate_expiry(1i)" => nil,
      )
    end

    it 'is valid' do
      expect(subject).to be_valid
    end
  end

  context 'when file is present without expiry date' do
    before(:each) do
      subject.validate(
        "product_liability_certificate_file" => example_pdf,
        "product_liability_certificate_expiry(3i)" => nil,
        "product_liability_certificate_expiry(2i)" => nil,
        "product_liability_certificate_expiry(1i)" => nil,
      )
    end

    it 'is is invalid' do
      expect(subject).to_not be_valid
      expect(subject.errors[:product_liability_certificate_expiry]).to be_present
    end
  end

  context 'when file is present with future date' do
    before(:each) do
      subject.validate(
        "product_liability_certificate_file" => example_pdf,
        "product_liability_certificate_expiry(3i)" => future_date.day,
        "product_liability_certificate_expiry(2i)" => future_date.month,
        "product_liability_certificate_expiry(1i)" => future_date.year,
      )
    end

    it 'is is valid' do
      expect(subject).to be_valid
    end
  end

  context 'when file is present with historical date' do
    before(:each) do
      subject.validate(
        "product_liability_certificate_file" => example_pdf,
        "product_liability_certificate_expiry(3i)" => historical_date.day,
        "product_liability_certificate_expiry(2i)" => historical_date.month,
        "product_liability_certificate_expiry(1i)" => historical_date.year,
      )
    end

    it 'is is invalid' do
      expect(subject).to_not be_valid
      expect(subject.errors[:product_liability_certificate_expiry]).to be_present
    end
  end

  context 'when expiry date is present without file' do
    before(:each) do
      subject.validate(
        "product_liability_certificate_file" => nil,
        "product_liability_certificate_expiry(3i)" => future_date.day,
        "product_liability_certificate_expiry(2i)" => future_date.month,
        "product_liability_certificate_expiry(1i)" => future_date.year,
      )
    end

    it 'is is invalid' do
      expect(subject).to_not be_valid
      expect(subject.errors[:product_liability_certificate_file]).to be_present
    end
  end
end
