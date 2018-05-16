require 'rails_helper'

RSpec.describe Sellers::SellerApplication::Documents::Contract::Financials do
  let(:seller) { create(:inactive_seller) }
  let(:application) { create(:seller_application, seller: seller) }

  subject { Sellers::SellerApplication::Documents::Contract::Financials.new(application: application, seller: seller) }

  let(:example_pdf) {
    Rack::Test::UploadedFile.new(
      Rails.root.join('spec', 'fixtures', 'files', 'example.pdf'),
      'application/pdf'
    )
  }
  let(:historical_date) { Date.today - 1.year }

  let(:atts) {
    {
      financial_statement: example_pdf,
      financial_statement_expiry: historical_date,
    }
  }

  it 'can save with valid attributes' do
    subject.validate(atts)

    expect(subject).to be_valid
    expect(subject.save).to eq(true)
  end

  context 'financial_statement' do
    it 'is invalid when blank' do
      subject.validate(atts.merge(financial_statement: nil))

      expect(subject).to_not be_valid
      expect(subject.errors[:financial_statement]).to be_present
    end

    it 'is invalid with an unsupported filetype' do
      invalid_file = Rack::Test::UploadedFile.new(
        Rails.root.join('spec', 'fixtures', 'files', 'invalid.html')
      )
      subject.validate(atts.merge(
        financial_statement: invalid_file
      ))

      expect(subject.save).to be_falsey
    end

    it 'is invalid with an unsupported content type' do
      invalid_file = Rack::Test::UploadedFile.new(
        Rails.root.join('spec', 'fixtures', 'files', 'example.pdf'),
        'text/html'
      )
      subject.validate(atts.merge(
        financial_statement: invalid_file
      ))

      expect(subject.save).to be_falsey
    end
  end

  context 'financial_statement_expiry' do
    it 'is invalid when blank' do
      subject.validate(atts.merge(financial_statement_expiry: nil))

      expect(subject).to_not be_valid
      expect(subject.errors[:financial_statement_expiry]).to be_present
    end
  end

  context 'given multi-parameter dates' do
    it 'builds a valid expiry date' do
      subject.validate(
        atts.except(:financial_statement_expiry).merge(
          "financial_statement_expiry(3i)" => historical_date.day,
          "financial_statement_expiry(2i)" => historical_date.month,
          "financial_statement_expiry(1i)" => historical_date.year,
        )
      )

      expect(subject).to be_valid
      expect(subject.financial_statement_expiry).to eq(historical_date)
    end
  end
end
